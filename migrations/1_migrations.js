var STORE = artifacts.require("Store");
var Ticket = artifacts.require("Ticket");


module.exports = async function(deployer, _, accounts) {
  try {
    await deployer.deploy(STORE);
    const store = await STORE.deployed() 
    console.log("Marketplace contract deployed to:", store.address);

    await deployer.deploy(Ticket, store.address);
    const ticket = await Ticket.deployed() 
    console.log("NFT contract deployed to:", store.address);
    
   
  } catch (e) {
    console.error(e);
  }
};
