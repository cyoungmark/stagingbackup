public class TWG_WebToCaseController {
    public Case c { get; set; }
    public String acctName { get; set; }

    public TWG_WebToCaseController() {

        c = new Case();

    }

    public PageReference submitCase() {

        List<Account> accts = [SELECT Id FROM Account WHERE Name = :acctName];
        
        if (c.Subject=='' || c.Description=='' || acctName==''){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please, complete required fields');
            ApexPages.addMessage(msg);
            return null;
        } else {

            if (accts.size() == 0) {
    
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Invalid account ' + acctName);
                ApexPages.addMessage(msg);
    
                return null;
    
            } else {
    
                try {
    
                    c.AccountId = accts.get(0).Id;
                    
                    // now look for an associated contact with the same email
                    Contact[] cnts = [SELECT Id FROM Contact WHERE Account.Id = :c.AccountId AND Email = :c.SuppliedEmail];
                    if (cnts != null && cnts.size() > 0)
                        c.ContactId = cnts[0].Id;
    
                    // Specify DML options to ensure the assignment rules are executed
                    Database.DMLOptions dmlOpts = new Database.DMLOptions();
                    dmlOpts.assignmentRuleHeader.useDefaultRule = true;
                    c.setOptions(dmlOpts);
    
                    // Insert the case
                    INSERT c;
                    return new PageReference('/apex/TWG_thanks');
    
                } catch (Exception e) {
                    ApexPages.addMessages(e);
                    return null;
                }
            }
        }
    }
}