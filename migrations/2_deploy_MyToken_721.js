require('dotenv').config()
var BigNumber = require('bignumber.js');

const {TOKEN_BASE_URI, TOKEN_PRICE} = process.env;
const MyToken_721 = artifacts.require("MyToken_721");

module.exports = function (deployer) {
  deployer.deploy(MyToken_721, TOKEN_BASE_URI, new BigNumber(TOKEN_PRICE));
};