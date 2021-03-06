/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

*/
component entityname="SlatwallTaskHistory" table="SwTaskHistory" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="scheduleService" {
	
	// Persistent Properties
	property name="taskHistoryID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="successFlag" ormtype="boolean";
	property name="response" ormtype="string";
	property name="startTime" ormtype="timestamp";
	property name="endTime" ormtype="timestamp";
	
	// Related Object Properties (many-to-one)
	property name="task" cfc="Task" fieldtype="many-to-one" fkcolumn="taskID";
	property name="taskSchedule" cfc="TaskSchedule" fieldtype="many-to-one" fkcolumn="taskScheduleID";
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	
	// Non-Persistent Properties
	property name="duration" persistent="false" hb_formatType="second";
	
	// ============ START: Non-Persistent Property Methods =================
	
	public any function getDuration() {
		if(!structKeyExists(variables, "duration")) {
			variables.duration = 0;
			if(!isNull(getStartTime()) && !isNull(getEndTime())) {
				variables.duration = dateDiff("s", getStartTime(), getEndTime());
			} else if (!isNull(getStartTime())) {
				variables.duration = dateDiff("s", getStartTime(), now());
			}
		}	
		return variables.duration;
	}
	
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Task (many-to-one)    
	public void function setTask(required any task) {    
		variables.task = arguments.task;    
		if(isNew() or !arguments.task.hasTaskHistory( this )) {    
			arrayAppend(arguments.task.getTaskHistories(), this);    
		}    
	}    
	public void function removeTask(any task) {    
		if(!structKeyExists(arguments, "task")) {    
			arguments.task = variables.task;    
		}    
		var index = arrayFind(arguments.task.getTaskHistories(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.task.getTaskHistories(), index);    
		}    
		structDelete(variables, "task");    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
