const Lottery = artifacts.require("Lottery");

// ganache-cli에서 생성된 주소가 순서대로 들어간다.
// deployer에 0번주소 user1에 1번 주소 

contract('Lottery',function([deployer,user1,user2]){
    let Lottery;
    beforeEach(async ()=>{
        console.log('Before each');
        Lottery = await Lottery.new();
    });

    if('Basic test', async()=>{
        console.log('Basic test');
        let owner = await Lottery.owner();
        let value = await Lottery.getSomeValue();

        console.log(owner);
        console.log(value);
        assert.equal(value,5)
    });

    if('get pot should return pot', async()=>{
        let pot = await Lottery.getPot();
        assert.equal(pot,0);
    });
});