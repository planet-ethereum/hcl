 /*global contract, config, it, assert*/
const HCL = require('Embark/contracts/HCL')

let accounts

config({
  deployment: {
    accounts: [
      {
        privateKey: '4f3edf983ac636a65a842ce7c78d9aa706d3b113bce9c46f30d7d21715b23b1d',
        balance: '5 ether'
      }
    ]
  },
  contracts: {
    HCL: {
      args: ['0x90f8bf6a479f320ead074411a4b0e7944ea8c9c1', '0x90f8bf6a479f320ead074411a4b0e7944ea8c9c1']
    }
  }
})

contract('HCL', function () {
  this.timeout(0)

  it('should set constructor value', async function () {
    console.log(await web3.eth.getCoinbase())
    let obj = await HCL.methods.object().call()
    obj = obj.substr(0, 42)
    assert.strictEqual(obj, '0x90f8bf6a479f320ead074411a4b0e7944ea8c9c1')

    let holder = await HCL.methods.holder().call()
    assert.strictEqual(holder.toLowerCase(), '0x90f8bf6a479f320ead074411a4b0e7944ea8c9c1')

    let permissions = await HCL.methods.permissions().call()
    assert.strictEqual(1, parseInt(permissions, 10))
  })

  it('should close source', async function () {
    await HCL.methods.closeSource(1000).send({ value: 500 })

    let permissions = await HCL.methods.permissions().call()
    assert.strictEqual(0, parseInt(permissions, 10))

    let price = await HCL.methods.stake().call()
    assert.strictEqual(500, parseInt(price, 10))
  })
})
