<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Tour_and_Tasting_Form_Approved</fullName>
        <description>Tour and Tasting Form Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Tours_and_Tastings_Templates/Tour_and_Tasting_Form_Approved</template>
    </alerts>
    <alerts>
        <fullName>Tour_and_Tasting_Form_Created_Carla</fullName>
        <description>Tour and Tasting Form Created - Carla</description>
        <protected>false</protected>
        <recipients>
            <recipient>boffac@terlatowines.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rocky@a2bapps.com.twg</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Tours_and_Tastings_Templates/Tour_and_Tasting_Form_Creation_Notification_Template</template>
    </alerts>
    <alerts>
        <fullName>Tour_and_Tasting_Form_Created_Leah</fullName>
        <description>Tour and Tasting Form Created - Leah</description>
        <protected>false</protected>
        <recipients>
            <recipient>ortegal@twg.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rocky@a2bapps.com.twg</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Tours_and_Tastings_Templates/Tour_and_Tasting_Form_Creation_Notification_Template</template>
    </alerts>
    <alerts>
        <fullName>Tour_and_Tasting_Form_Rejected</fullName>
        <description>Tour and Tasting Form Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Tours_and_Tastings_Templates/Tour_and_Tasting_Form_Rejected_Template</template>
    </alerts>
    <alerts>
        <fullName>Tour_and_Tasting_Form_Request_for_Approval</fullName>
        <description>Tour and Tasting Form Request for Approval - Leah</description>
        <protected>false</protected>
        <recipients>
            <recipient>ortegal@twg.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rocky@a2bapps.com.twg</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Tours_and_Tastings_Templates/Tour_and_Tasting_Form_Approval_Request_Template</template>
    </alerts>
    <alerts>
        <fullName>Tour_and_Tasting_Form_Request_for_Approval_Carla</fullName>
        <description>Tour and Tasting Form Request for Approval - Carla</description>
        <protected>false</protected>
        <recipients>
            <recipient>boffac@terlatowines.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rocky@a2bapps.com.twg</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Tours_and_Tastings_Templates/Tour_and_Tasting_Form_Approval_Request_Template</template>
    </alerts>
    <alerts>
        <fullName>Tour_and_Tasting_Guest_Itinerary</fullName>
        <description>Tour and Tasting Guest Itinerary</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Guest_Name__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Tours_and_Tastings_Templates/Tour_and_Tasting_Guest_Itinerary</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approve_Itinerary</fullName>
        <field>Itinerary_Approved__c</field>
        <literalValue>1</literalValue>
        <name>Approve Itinerary</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Record_Owner_to_Internal</fullName>
        <field>OwnerId</field>
        <lookupValue>DTC</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change Record Owner to Internal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_T_T_Form_Status_to_Rejected</fullName>
        <field>Tour_Form_Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Change T&amp;T Form Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Status_to_Pending</fullName>
        <field>Tour_Form_Approval_Status__c</field>
        <literalValue>Submit_for_Approval</literalValue>
        <name>Set Approval Status to Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Itinerary_Approved_Date</fullName>
        <field>Itinerary_Approved_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set Itinerary Approved Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_approved_status_to_Approved</fullName>
        <field>Tour_Form_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Set approved status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>T_T_Form_Approval_Status_to_Pending</fullName>
        <field>Tour_Form_Approval_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>T&amp;T Form Approval Status to Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tour_Tasting_Approved</fullName>
        <field>Tour_Form_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Tour &amp; Tasting Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tour_and_Tasting_Form_Creation_Record</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Tour_and_Form_Approver</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Tour and Tasting Form - Creation Record</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Submission_Date_field</fullName>
        <description>Sets the Submission Date field to the date that the User submitted the T&amp;T Form for approval.</description>
        <field>Submission_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Submission Date field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Change TT Form Record Type</fullName>
        <actions>
            <name>Tour_and_Tasting_Form_Creation_Record</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Tours_and_Tastings__c.CreatedDate</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Change the Tour and Tasting Form record type after creation</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Check box to send Final Itinerary to Guests</fullName>
        <actions>
            <name>Tour_and_Tasting_Guest_Itinerary</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Tours_and_Tastings__c.Send_Guest_Itinerary__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tour and Tasting Form - Alert Carla</fullName>
        <actions>
            <name>Tour_and_Tasting_Form_Created_Carla</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Tours_and_Tastings__c.Owner_Region__c</field>
            <operation>equals</operation>
            <value>Carla</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Tour and Tasting Form - Alert Leah</fullName>
        <actions>
            <name>Tour_and_Tasting_Form_Created_Leah</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Tours_and_Tastings__c.Owner_Region__c</field>
            <operation>equals</operation>
            <value>Leah</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Tour and Tasting Form - Approved</fullName>
        <actions>
            <name>Tour_and_Tasting_Form_Approved</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Tours_and_Tastings__c.Tour_Form_Approval_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tour and Tasting Form - Creation Record Type Update</fullName>
        <actions>
            <name>Tour_and_Tasting_Form_Creation_Record</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Tours_and_Tastings__c.Tour_Form_Approval_Status__c</field>
            <operation>equals</operation>
            <value>Submit_for_Approval</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Tour and Tasting Form - Rejected</fullName>
        <actions>
            <name>Tour_and_Tasting_Form_Rejected</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Tours_and_Tastings__c.Tour_Form_Approval_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tour and Tasting Form - Submit for Approval - Carla</fullName>
        <actions>
            <name>Tour_and_Tasting_Form_Request_for_Approval_Carla</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Tours_and_Tastings__c.Tour_Form_Approval_Status__c</field>
            <operation>equals</operation>
            <value>Submit_for_Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Tours_and_Tastings__c.Owner_Region__c</field>
            <operation>equals</operation>
            <value>Carla</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tour and Tasting Form - Submit for Approval - Leah</fullName>
        <actions>
            <name>Tour_and_Tasting_Form_Request_for_Approval</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Tours_and_Tastings__c.Tour_Form_Approval_Status__c</field>
            <operation>equals</operation>
            <value>Submit_for_Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Tours_and_Tastings__c.Owner_Region__c</field>
            <operation>equals</operation>
            <value>Leah</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Approve_Final_Itinerary</fullName>
        <assignedTo>branyikv@twg.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Approve Final Itinerary</subject>
    </tasks>
</Workflow>
