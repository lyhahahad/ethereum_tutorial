async function main() {
  console.log(100);
  const NFTMarket = await ethers.getContractFactory("NFTMarket")
  const nftmarket = await NFTMarket.deploy()
  await nftmarket.deployed()
  console.log("Contract deployed to address:", nftmarket.address)

  const NFT = await ethers.getContractFactory("NFT");
  const nft = await NFT.deploy(nftMarket.address);
  await nft.deployed();
  console.log("nft deployed to:", nft.address);
}