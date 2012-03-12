/*  
 * Copyright (C) 2005-2007 Alfresco Software Limited.
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
  
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

 * As a special exception to the terms and conditions of version 2.0 of 
 * the GPL, you may redistribute this Program in connection with Free/Libre 
 * and Open Source Software ("FLOSS") applications as described in Alfresco's 
 * FLOSS exception.  You should have recieved a copy of the text describing 
 * the FLOSS exception, and it is also available here: 
 * http://www.alfresco.com/legal/licensing"
 */
 package alfresco.authentication
{
	import flash.events.Event;
	import flash.profiler.showRedrawRegions;
	
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.rpc.soap.WebService;
	
	import flash.events.EventDispatcher;
	import alfresco.error.ErrorService;
	import alfresco.webscript.SuccessEvent;
	import  alfresco.webscript.FailureEvent;
	import  alfresco.webscript.ConfigService;
	import  alfresco.webscript.WebScriptService;

	/**
	 * Authentication service class.
	 * 
	 * @author Roy Wetherall
	 */
	public class AuthenticationService extends EventDispatcher
	{
		/** Static instance of the authentication service */
		private static var _instance:AuthenticationService;
		
		/** The current authentication ticket */
		private var _ticket:String = null;		
		
		/** The currently authenticated user name */
		private var _userName:String = null;
		
		/**
		 * Singleton method to get the instance of the Authentication Service
		 */
		public static function get instance():AuthenticationService
		{
			if (AuthenticationService._instance == null)
			{
				AuthenticationService._instance = new AuthenticationService();
			}
			return AuthenticationService._instance;
		}
			
		/**
		 * Getter for the ticket property
		 */		
		public function get ticket():String
		{
			return this._ticket;
		}		
		
		/**
		 * Getter for the userName property
		 */
		public function get userName():String
		{
			return this._userName;
		}
		
		/**
		 * Indicates whether we are logged in or not
		 */
		public function get isLoggedIn():Boolean
		{
			var result:Boolean = false;
			if (this._ticket != null)
			{
				result = true;
			}
			return result;
		}
		
		/**
		 * Log in a user to the Alfresco repository and store the ticket.
		 */
		public function login(userName:String, password:String):void
		{
			// Store the user name
			this._userName = userName;
			
			// Create the web script obejct
			var url:String = ConfigService.instance.url + "/alfresco/service/api/login";
			var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onLoginSuccess, onLoginFailure, false);
			
			// Build the parameter object
			var params:Object = new Object();
			params.u = userName;
			params.pw = password;
		
			// Execute the web script
			webScript.execute(params);
		}
		
		/**
		 * Log the current user out of the Alfresco repository
		 */
		public function logout():void
		{
			// Execute the logout web script
			var url:String = ConfigService.instance.url + "/alfresco/service/api/login/ticket/" + this._ticket;				
			var webScript:WebScriptService = new WebScriptService(url, WebScriptService.DELETE, onLogoutSuccess);
			webScript.execute();										
		}
		
		/**
		 * On logout success event handler
		 */
		public function onLogoutSuccess(event:SuccessEvent):void
		{
			// Clear the current ticket information
			this._ticket = null;
			this._userName = null;
			
			// Raise on logout success event
			dispatchEvent(new LogoutCompleteEvent(LogoutCompleteEvent.LOGOUT_COMPLETE));			
		}
		
		/**
		 * On login success event handler
		 */
		public function onLoginSuccess(event:SuccessEvent):void
		{
			// Store the ticket in the authentication service
			this._ticket = event.result.ticket;
			
			// Raise on login success event
			dispatchEvent(new LoginCompleteEvent(LoginCompleteEvent.LOGIN_COMPLETE, this._ticket, ""));
		}
		
		/**
		 * On login failure event handler
		 */
		public function onLoginFailure(event:FailureEvent):void
		{
			// Clear the user name
			this._userName = null;
			
			// Get the error details from the failure event
			var code:String = event.fault.faultCode;
			var message:String = event.fault.faultString;
			var details:String = event.fault.faultDetail;
			
			if (code == "403")
			{
				// Raise invalid credentials error	
				ErrorService.instance.raiseError(InvalidCredentialsError.INVALID_CREDENTIALS, new InvalidCredentialsError());
			}
			else
			{
				// TODO extend the parameters provided here ...
				
				// Raise general authentication error
				ErrorService.instance.raiseError(ErrorService.APPLICATION_ERROR, new AuthenticationError(message));
			}
		}
	}
}