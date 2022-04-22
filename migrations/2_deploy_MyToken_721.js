const MyToken_721 = artifacts.require("MyToken_721");

module.exports = function (deployer) {
  deployer.deploy(MyToken_721, "QmdZPLxvCir51buGEZ4pRC8yWZXxDfmEseiwq8XAq3NiPe");
};
