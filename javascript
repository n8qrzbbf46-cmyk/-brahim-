
 let customerProfile = null;
 let ProductsCatalog = [];
 function setPustomerProfile (fullName,  email,  phoneNumber) {
   customerProfile = {
      name: fullName,
      email: email,
      phone: phoneNumber,
   }
   retrun "SUCCESS: Customer registeret.";
}
function createProduct(title, price, description, videUrl, vendorPhone)
let cleanPhone = vendorPhone.replace(/[^0-9]/ "");
const newProduct = {
   id Date.now (),
   title: title 
   price: parseFolat(price),
   desct: description
   video: videoUrl 
   phone: cleanPhone
};
ProductsCatalog.push(newProduct);
retrun Product;
} 
function generateWhatsApp0rderUrl(ProductId) {
   const Product = ProductsCatalog.find(item => item.ıd === ProductId)
   if (!Product) return "ERROR: Product not found.";

   let buyerMeta = "(Guest Checkout)";
   if (customerProfile) {
      buyerMeta = Buyer Name: $(customerProfile.name) | Phone: $(customerProfile.phone)':
   } 
   let messageText = ORDER DETAIL: %0A- Product $(Product.title)%0A- price: $$(Product.price)%0A- Info: $(buyerMeta)':
   retrun https://wa.me{Product.phone}?text=$(messageText)';



            
                
        
        
 
    
  