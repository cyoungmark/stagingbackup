public class SL_DynTblRes
{
  public sObject[] recs;
  public SL_FldObj[] fldMap;
  public String sortDir;
  public String sortFld;
  public String errMsg;
  public Boolean createAccess;
  public String titledObjectName;

  public SL_DynTblRes(sObject[] recs, SL_FldObj[] fldMap, String sortDir, String sortFld, String errMsg, Boolean createAccess, String titledObjectName)
  {
    this.recs = recs;
    this.fldMap = fldMap;
    this.sortDir = sortDir;
    this.sortFld = sortFld;
    this.errMsg = errMsg;
    this.createAccess = createAccess;
    this.titledObjectName = titledObjectName;
  }
}