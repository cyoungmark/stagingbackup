public class SL_FldObj
{
  public String label;
  public String apiName;
  public String fldType;
  public Boolean isRef;
  public String lkupRelAPI;
  public String lkupRelName;
  public String invalidField;

  public SL_FldObj(String apiName,
                   String label,
                   String fldType,
                   Boolean isRef,
                   String lkupRelAPI,
                   String lkupRelName,
                   String invalidField)
  {
    this.apiName = apiName;
    this.label = label;
    this.fldType = fldType;
    this.isRef = isRef;
    this.lkupRelAPI = lkupRelAPI;
    this.lkupRelName = lkupRelName;
    this.invalidField = invalidField; 
  }
}