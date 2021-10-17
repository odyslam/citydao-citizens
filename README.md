# CityDAO citizen NFTs

CityDAO is the first experiment on tokenizing land, leveraging Wyoming's new law framework.

CityDAO citizens NFT owners participate in the governance of the CityDAO LLC, discussing and deciding on all matters.

There are 3 types of CityDAO citizens:
- Regular Citizens
- Founding Citizens
- First Citizen

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

### Security Notes

These smart contracts are being provided as is. No guarantee, representation or warranty is being made, express or implied, as to the safety or correctness of the user interface or the smart contracts. They have not been audited and as such there can be no assurance they will work as intended, and users may experience delays, failures, errors, omissions, loss of transmitted information or loss of funds. CityDAO LLC is not liable for any of the foregoing. Users should proceed with caution and use at their own risk.

### License

MIT License
