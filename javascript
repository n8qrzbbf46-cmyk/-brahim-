const Products = [
    {name: "Quantum  Processor V1", category: "Hardware"},
    {name: "Al Neural Engine", category: "Software"},
    {name: "Atomic Modeling Kit", category: "Simulation"}
 ]
 function renderProducts (Productlist){
    const market = doucment.getElementById ('market')
    market.innetHTML = Productlist.map(item => '
        <div class="card"> 
        <h3>${item.name}</h3> 
        <p>Category: ${item.category}</p>
        <a href="https:// wa.me/905XXXXXXXXX" class="btn-wa"> Contact seller</a>
    </div> 
 ').jon('');
 } 
 function filterProducts() {
    let searchTerm = document.gtElementById('searchInput').value.tolowerCase();
    let filtered = Products.filter(p => p.name.tolowerCase().includes (searchTerm));
    renderProducts(filtered);
 }
 //Initial load
 renderProducts(Products);
    
 



            
                
        
        
 
    
  