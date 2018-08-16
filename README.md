# HCL
This is a simple and experimental implementation of the clever Hive Commons License [proposed](https://medium.com/hive-commons/harberger-taxation-and-open-source-58dcdbab140d)
by Hive Commons to create a variant between permissive and strict license types, in which
anyone can derive work from a project with a HCL if they adopt the same license. However proprietary
derivative works should announce a self-assessed valuation of their project, and accordingly pay a
harberger taxation which could potentially benefit various beneficiaries. At any point, if someone
decides so, they can pay the self-assessed price, and "free" the work.

*Note:* this project is not suitable at all for mainnet deployment, please refrain from doing so.

## How it works
We go through a scenario in which an open source operating system adopts the HCL. Their source code can be found
at `kernel.cool-os.eth`.

### Cool-OS licensing
The owner of Cool-OS deploys an instance of the `HCL` contract, with a pointer to the object (`kernel.cool-os.eth`),
and an address which refers to the license holder. They mention the address of this contract in their
`LICENSE` file, as a single source of truth.

### Proprietary derivation
If someone wants to derive from this work without releasing their source code, they deploy an instance
of the `HCL` contract, pointing to their object (`kernel.macrosoft.eth`) and after deployment,
send a transaction to the `closeSource` method, specifying their self-assessed price, and
sending some ether to be used for future tax collections.

#### Tax collection
To pay the tax, anyone can call the `payTax` method of a closed license, and it calculates the amount that
needs to be paid since the last tax collection, assuming an annual 7% ratio.

#### Liberating the work
Anyone can now call the `free` method of the `macrosoft` license, sending enough ether to cover the price
in which case the license becomes open.

## Possible extensions
This simple model could be extended to allow for various license models and a linux-like permission
system, which determines under what conditions someone can derive from this work, and under which
conditions they must pay tax and announce a price. Other projects could in turn specify a list of
license dependencies which would determine the possible license permissions for them.

# Contribute
Please feel free to create an issue or a PR for anything.
