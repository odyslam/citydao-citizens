# CityDAO citizen NFTs

CityDAO is the first experiment on tokenizing land, leveraging Wyoming's new law framework.

CityDAO citizens NFT owners participate in the governance of the CityDAO LLC, discussing and deciding on all matters.

There are 3 types of CityDAO citizens:
- Regular Citizens
- Founding Citizens
- First Citizen

## Implementation Notes

- ERC1155 is used to represent tokens
- Token ID:
    - Citizen NFTs: 42
    - Founding Citizen NFTs: 69
    - First Citizen NFTs: 7
- EIP2981 is used to store preferred royalties from secondary-market sales.
- An airdrop function is used to airdrop Citizen NFTs to owners of the old, OpenSea shared Storefront Citizen NFTs.
- Users can purchase Citizen NFTs by sending Ether to the smart contract and calling a specific function.

### Functionality
- `OnlineApplicationForCitizenship`: Request a number of Citizen NFTs from the owner of the smart contract (CityDAO). User must transfer `citizenshipStampCostInWei` WEI for every NFT.
- `issueNewCitizenships`: Mint new Citizen NFTs to a specified address. Can only be called by the owner of the smart contract.
- `initialCitizenship`: Bootstrapping method that mints the initial batch of Citizen NFTs, as of the day the smart contract is published. Called by the owner, once.
- `legislateCostOfEntry`: Define a new `citizenshipStampCostInWei` requirement for Citizen NFTs.
- `inquireCostOfEntry`: Return the current `citizenshipStampCostInWei`
- `inquireHousingNumber`: Return the number of minted Citizen NFTs.
- `inquireAboutHistory`: Return the number of minted Founding Citizen NFTs.
- `raidTheCoffers`: Withdraw the funds from the smart contract. The funds originate from the purchases of Citizen NFTs. It can be called only by the owner.
- `awardCitizenship`: Airdrop citizen NFTs from the owner (cityDAO) to addresses
- `changeURIs`: Change the URI of the citizen NFTs.
- `setDefaultRoyalty`: Set the default royalty to be used for all tokens, if token-specific royalty is not found. Called only by owner.
- `setTokenRoyalty`: Set token-specific royalty. Called only by owner.
- `royaltyInfo`: Returns the current royalty settings for this ERC1155.

## Building and testing

```sh
git clone https://github.com/odyslam/citydao-citizens
cd citydao-citizens
make
make test
```

## Installing the toolkit

If you do not have DappTools already installed, you'll need to run the below
commands

### Install Nix

```sh
# User must be in sudoers
curl -L https://nixos.org/nix/install | sh

# Run this or login again to use Nix
. "$HOME/.nix-profile/etc/profile.d/nix.sh"
```

### Install DappTools

```sh
curl https://dapp.tools/install | sh
```

### Security Notes

These smart contracts are being provided as is. No guarantee, representation or warranty is being made, express or implied, as to the safety or correctness of the user interface or the smart contracts. They have not been audited and as such there can be no assurance they will work as intended, and users may experience delays, failures, errors, omissions, loss of transmitted information or loss of funds. CityDAO LLC is not liable for any of the foregoing. Users should proceed with caution and use at their own risk.

### License

MIT License
