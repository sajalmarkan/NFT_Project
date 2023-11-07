async function main(){
    const NFTMartet =await ethers.getContractFactory("Cricketers");
    const HardhatMarketPlace= await NFTMartet.deploy();
    console.log("address required",await HardhatMarketPlace.getAddress());

    // const data={
    //     address :HardhatMarketPlace.getAddress(),
    //     abi:Json.parse(HardhatMarketPlace.interface,format('json'))
    // }

    // fs.writeFileSync('./src/Marketplace.json',JSON.stringify(data))

}
main()
    .then(()=>process.exit(0))
    .catch((error)=>{
        console.error(error);
        process.exit(1);
    });