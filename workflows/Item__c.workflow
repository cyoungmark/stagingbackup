<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Costing_Completed</fullName>
        <description>Costing Completed</description>
        <protected>false</protected>
        <recipients>
            <recipient>becerrak@twg.com.prod</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>changizip@twg.com.prod</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IIP_Approval_Templates/Costing_Complete_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_to_Accounting_of_Pending_Costing</fullName>
        <description>Email Alert to Accounting of Pending Costing</description>
        <protected>false</protected>
        <recipients>
            <recipient>becerrak@twg.com.prod</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>changizip@twg.com.prod</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IIP_Approval_Templates/Costing_Complete_Notification</template>
    </alerts>
    <alerts>
        <fullName>Item_Active_has_been_Updated</fullName>
        <ccEmails>jonathan@cipaq.com</ccEmails>
        <description>Item Active has been Updated</description>
        <protected>false</protected>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IIP_Approval_Templates/Item_Active_Marketing_Update</template>
    </alerts>
    <alerts>
        <fullName>New_Item_Active_Created</fullName>
        <description>New Item Active Created</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IIP_Approval_Templates/New_Item_Active_created</template>
    </alerts>
    <alerts>
        <fullName>New_Item_Active_Created_Updated</fullName>
        <description>New Item Active Created/Updated</description>
        <protected>false</protected>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IIP_Approval_Templates/New_Item_Active_created_updated</template>
    </alerts>
    <fieldUpdates>
        <fullName>Costing_Complete_Status_Send_to_JDE</fullName>
        <field>Status__c</field>
        <literalValue>Send to JDE</literalValue>
        <name>Costing Complete Status &apos;Send to JDE&apos;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Erase_Costing_Comments</fullName>
        <field>Costing_Comments__c</field>
        <name>Erase Costing Comments</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Flip_Record_Type_to_IA_Locked</fullName>
        <field>RecordTypeId</field>
        <lookupValue>IA_Locked</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Flip Record Type to IA Locked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Flip_Record_Type_to_IA_Locked_Costing</fullName>
        <field>RecordTypeId</field>
        <lookupValue>IA_Locked_Costing</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Flip Record Type to IA Locked Costing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Item_Active_StatusUpdate_Send_to_JDE</fullName>
        <field>Status__c</field>
        <literalValue>Send to JDE</literalValue>
        <name>Item - Active StatusUpdate &apos;Send to JDE&apos;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Item_Name_Concatenated</fullName>
        <field>Name</field>
        <formula>Brand__r.Name  + &apos;-&apos; + 
TEXT (Vintage__c) + &apos;-&apos; + 
Marketing_Product_Name__c</formula>
        <name>Item Name Concatenated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Last_Costing_Completed</fullName>
        <field>Last_Cost_Completed_TimeStamp__c</field>
        <formula>NOW ()</formula>
        <name>Last Costing Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Last_Mktg_Update</fullName>
        <field>Last_Mktg_Update_TimeStamp__c</field>
        <formula>NOW ()</formula>
        <name>Last Mktg Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Pending_Costing</fullName>
        <field>Status__c</field>
        <literalValue>Pending Costing</literalValue>
        <name>Status = Pending Costing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_change_on_Mktg_Update</fullName>
        <field>Status__c</field>
        <literalValue>Marketing Updated</literalValue>
        <name>Status change on Mktg Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Converted_from_IIP</fullName>
        <field>Convert__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Converted from IIP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Costing_Complete</fullName>
        <field>Costing_Complete__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Costing Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Marketing_Update</fullName>
        <field>Marketing_Update__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Marketing Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Pending_Costing_Complete</fullName>
        <field>Pending_Costing_Complete__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Pending Costing Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Costing Complete</fullName>
        <actions>
            <name>Flip_Record_Type_to_IA_Locked</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_Pending_Costing_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Item__c.Costing_Complete__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Alert to Accounting of Pending Costing</fullName>
        <actions>
            <name>Email_Alert_to_Accounting_of_Pending_Costing</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Item__c.Pending_Costing_Complete__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Item__c.Status__c</field>
            <operation>equals</operation>
            <value>JDE Updated</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IIP successfully converted to IA</fullName>
        <actions>
            <name>New_Item_Active_Created_Updated</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Flip_Record_Type_to_IA_Locked_Costing</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Item_Active_StatusUpdate_Send_to_JDE</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_Converted_from_IIP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Item__c.Convert__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Item Name Concatenated</fullName>
        <actions>
            <name>Item_Name_Concatenated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>1=1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Last Costing Completed</fullName>
        <actions>
            <name>Last_Costing_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Item__c.Costing_Complete__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Last Mktg Update</fullName>
        <actions>
            <name>Last_Mktg_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Item__c.Marketing_Update__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Marketing Updated</fullName>
        <actions>
            <name>Item_Active_has_been_Updated</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Flip_Record_Type_to_IA_Locked</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Status_change_on_Mktg_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_Marketing_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Item__c.Marketing_Update__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Item Active Created</fullName>
        <actions>
            <name>New_Item_Active_Created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>1=1</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
