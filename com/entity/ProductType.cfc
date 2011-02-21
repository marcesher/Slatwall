component displayname="Product Type" entityname="SlatwallProductType" table="SlatwallProductType" persistent="true" extends="slatwall.com.entity.baseEntity" {
			
	// Persistant Properties
	property name="productTypeID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="productType" ormtype="string" validateRequired displayname="Product Type" default="";
	
	// Related Object Properties
	property name="parentProductType" cfc="ProductType" fieldtype="many-to-one" fkcolumn="parentProductTypeID";
	property name="subProductTypes" cfc="ProductType" singularname="SubProductType" fieldtype="one-to-many" inverse="true" fkcolumn="parentProductTypeID" cascade="all";
	property name="Products" cfc="Product" singularname="Product" fieldtype="one-to-many" inverse="true" fkcolumn="productTypeID" lazy="extra" cascade="all";
	
	// Calculated Properties
	property name="isAssigned" type="boolean" formula="SELECT count(sp.productID) from SlatwallProduct sp INNER JOIN SlatwallProductType spt on sp.productTypeID = spt.productTypeID where sp.productTypeID=productTypeID LIMIT 1";
	
	public ProductType function init(){
	   // set default collections for association management methods
	   if(isNull(variables.Products))
	       variables.Products = [];
	   return Super.init();
	}
	
	// Association management methods for bidirectional relationships (delegates both sides to Product.cfc)
	public void function addProduct(required Product Product) {
	   arguments.Product.setProductType(this);
	}
	
	public void function removeProduct(required Product Product) {
	   arguments.Product.removeProductType(this);
	}
}