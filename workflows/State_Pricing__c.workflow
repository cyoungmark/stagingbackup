<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_1_Up_Charge_CIF_field</fullName>
        <description>Sets the value for the 1% Up Charge field for CIF.</description>
        <field>X1_Up_Charge_CIF__c</field>
        <formula>(State_Adjustment_Reference__r.Base_Price__c +   Item_Update__r.CIF_Upcharge__r.CIF_Upcharge__c   + State_Adjustment__c + Other_Adjustments__c) * 0.01</formula>
        <name>Update 1% Up Charge CIF field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_1_Up_Charge_WHSE_field</fullName>
        <description>Sets the value for the 1% Up Charge field for WHSE.</description>
        <field>X1_Up_Charge_WHSE__c</field>
        <formula>(State_Adjustment_Reference__r.Base_Price__c +    Item_Update__r.Warehouse_Upcharge__r.WhsUpcharge__c   + State_Adjustment__c + Other_Adjustments__c)* 0.01</formula>
        <name>Update 1% Up Charge WHSE field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_State_Pricing_R_T_to_Item_Active</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Item_Active</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update State Pricing R/T to Item-Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_State_Pricing_R_T_to_Item_In_Pro</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Item_In_Process</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update State Pricing R/T to Item-In Pro</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Edit State Pricing on Item - In Process</fullName>
        <actions>
            <name>Update_State_Pricing_R_T_to_Item_In_Pro</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>State_Pricing__c.Item_In_Process_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>State_Pricing__c.Locked__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lock State Pricing on Item - Active</fullName>
        <actions>
            <name>Update_State_Pricing_R_T_to_Item_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>State_Pricing__c.Item_Active_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set 1%25 Upcharge CIF - NY</fullName>
        <actions>
            <name>Update_1_Up_Charge_CIF_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>State_Pricing__c.State__c</field>
            <operation>equals</operation>
            <value>NY</value>
        </criteriaItems>
        <description>Sets the 1% upcharge for CIF</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set 1%25 Upcharge WHSE - NY</fullName>
        <actions>
            <name>Update_1_Up_Charge_WHSE_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>State_Pricing__c.State__c</field>
            <operation>equals</operation>
            <value>NY</value>
        </criteriaItems>
        <description>Sets the 1% upcharge for Warehouse</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
