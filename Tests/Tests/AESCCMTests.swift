////  CryptoSwift
//
//  Copyright (C) 2014-__YEAR__ Marcin Krzyżanowski <marcin@krzyzanowskim.com>
//  This software is provided 'as-is', without any express or implied warranty.
//
//  In no event will the authors be held liable for any damages arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
//
//  - The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation is required.
//  - Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
//  - This notice may not be removed or altered from any source or binary distribution.
//

@testable import CryptoSwift
import Foundation
import XCTest

final class AESCCMTests: XCTestCase {

    struct TestFixture {
        let tagLength: Int
        let key: Array<UInt8>
        let nonce: Array<UInt8>
        let aad: Array<UInt8>
        let plaintext: Array<UInt8>
        let expected: Array<UInt8>

        init(_ tagLength: Int, _ key: String, _ nonce: String,  _ plaintext: String, _ expected: String, _ aad: String) {
            self.tagLength = tagLength
            self.key = Array<UInt8>(hex: key)
            self.nonce = Array<UInt8>(hex: nonce)
            self.aad = Array<UInt8>(hex: aad)
            self.plaintext = Array<UInt8>(hex: plaintext)
            self.expected = Array<UInt8>(hex: expected)
        }
    }

    func testAESCCMTestDVPT256() {
        let fixtures = [
            //NIST Test vectors for AES-CCM with 256bit Key, from DVPT256.txt
            //(Integer macLength, String key, String nonce, String plain, String ciphered, String aData) {
            TestFixture(4, "eda32f751456e33195f1f499cf2dc7c97ea127b6d488f211ccc5126fbb24afa6", "a544218dadd3c1", "", "469c90bb", ""),
            TestFixture(4, "eda32f751456e33195f1f499cf2dc7c97ea127b6d488f211ccc5126fbb24afa6", "dbb3923156cfd6", "", "1302d515", ""),
            TestFixture(4, "eda32f751456e33195f1f499cf2dc7c97ea127b6d488f211ccc5126fbb24afa6", "a259c114eaac89", "", "4fe06e92", ""),
            TestFixture(4, "eda32f751456e33195f1f499cf2dc7c97ea127b6d488f211ccc5126fbb24afa6", "e1be89af98ffd7", "", "e5417f6b", ""),
            TestFixture(4, "eda32f751456e33195f1f499cf2dc7c97ea127b6d488f211ccc5126fbb24afa6", "1aa758eb2f9a28", "", "f8fa8e71", ""),
            TestFixture(16, "e1b8a927a95efe94656677b692662000278b441c79e879dd5c0ddc758bdc9ee8", "a544218dadd3c1", "", "8207eb14d33855a52acceed17dbcbf6e", ""),
            TestFixture(16, "e1b8a927a95efe94656677b692662000278b441c79e879dd5c0ddc758bdc9ee8", "dbb3923156cfd6", "", "e4dc5e03aacea691262ee69cee8ffbbe", ""),
            TestFixture(16, "e1b8a927a95efe94656677b692662000278b441c79e879dd5c0ddc758bdc9ee8", "a259c114eaac89", "", "f79c53fd5e69835b7e70496ea999718b", ""),
            TestFixture(16, "e1b8a927a95efe94656677b692662000278b441c79e879dd5c0ddc758bdc9ee8", "e1be89af98ffd7", "", "10d3f6fe08280d45e67e58fe41a7f036", ""),
            TestFixture(16, "e1b8a927a95efe94656677b692662000278b441c79e879dd5c0ddc758bdc9ee8", "1aa758eb2f9a28", "", "2590df2453cb94c304ba0a2bff3f3c71", ""),
            TestFixture(4, "e1b8a927a95efe94656677b692662000278b441c79e879dd5c0ddc758bdc9ee8", "a544218dadd3c10583db49cf39", "", "8a19a133", ""),
            TestFixture(4, "e1b8a927a95efe94656677b692662000278b441c79e879dd5c0ddc758bdc9ee8", "79ac204a26b9fee1132370c20f", "", "154024b2", ""),
            TestFixture(4, "e1b8a927a95efe94656677b692662000278b441c79e879dd5c0ddc758bdc9ee8", "0545fd9ecbc73ccdbbbd4244fd", "", "5c349fb2", ""),
            TestFixture(4, "e1b8a927a95efe94656677b692662000278b441c79e879dd5c0ddc758bdc9ee8", "0a37f2e7c66490e97285f1b09e", "", "c59bf14c", ""),
            TestFixture(4, "e1b8a927a95efe94656677b692662000278b441c79e879dd5c0ddc758bdc9ee8", "c1ad812bf2bbb2cdaee4636ee7", "", "5b96f41d", ""),
            TestFixture(16, "af063639e66c284083c5cf72b70d8bc277f5978e80d9322d99f2fdc718cda569", "a544218dadd3c10583db49cf39", "","97e1a8dd4259ccd2e431e057b0397fcf", ""),
            TestFixture(16, "af063639e66c284083c5cf72b70d8bc277f5978e80d9322d99f2fdc718cda569", "79ac204a26b9fee1132370c20f", "", "5c8c9a5b97be8c7bc01ca8d693b809f9", ""),
            TestFixture(16, "af063639e66c284083c5cf72b70d8bc277f5978e80d9322d99f2fdc718cda569", "0545fd9ecbc73ccdbbbd4244fd", "", "84201662b213c7a1ff0c1b3c25e4ec45", ""),
            TestFixture(16, "af063639e66c284083c5cf72b70d8bc277f5978e80d9322d99f2fdc718cda569", "0a37f2e7c66490e97285f1b09e", "", "586e728193ce6db9a926b03b2d77dd6e", ""),
            TestFixture(16, "af063639e66c284083c5cf72b70d8bc277f5978e80d9322d99f2fdc718cda569", "c1ad812bf2bbb2cdaee4636ee7", "", "64864d21b6ee3fca13f07fc0486e232d", ""),
            TestFixture(4, "af063639e66c284083c5cf72b70d8bc277f5978e80d9322d99f2fdc718cda569", "a544218dadd3c1", "d3d5424e20fbec43ae495353ed830271515ab104f8860c98", "64a1341679972dc5869fcf69b19d5c5ea50aa0b5e985f5b722aa8d59", ""),
            TestFixture(4, "af063639e66c284083c5cf72b70d8bc277f5978e80d9322d99f2fdc718cda569", "9d773a31fe2ec7", "839d8cfa2c921c3cceb7d1f46bd2eaad706e53f64523d8c0", "5acfbe5e488976d8b9b77e69a736e8c919053f9415551209dce2d25e", ""),
            TestFixture(4, "af063639e66c284083c5cf72b70d8bc277f5978e80d9322d99f2fdc718cda569", "24b7a65391f88b", "3bed52236182c19418867d468dbf47c8aac46c02445f99bb", "f00628e10e8e0115b4a4532a1212a23aade4090832c1972d750125f3", ""),
            TestFixture(4, "af063639e66c284083c5cf72b70d8bc277f5978e80d9322d99f2fdc718cda569", "b672c91376f533", "4f7a561e61b7861719e4445057ac9b74a9be953b772b09ec", "758aa03dc72c362c43b5f85bfaa3db4a74860887a8c29e47d5642830", ""),
            TestFixture(4, "af063639e66c284083c5cf72b70d8bc277f5978e80d9322d99f2fdc718cda569", "a6d01fb88ca547", "a36155de477364236591e453008114075b4872120ef17264", "615cbeabbe163ba8bc9c073df9ad40833fcf3f424644ccc37aa999d7", ""),
            TestFixture(16, "f7079dfa3b5c7b056347d7e437bcded683abd6e2c9e069d333284082cbb5d453", "a544218dadd3c1", "d3d5424e20fbec43ae495353ed830271515ab104f8860c98", "bc51c3925a960e7732533e4ef3a4f69ee6826de952bcb0fd374f3bb6db8377ebfc79674858c4f305", ""),
            TestFixture(16, "f7079dfa3b5c7b056347d7e437bcded683abd6e2c9e069d333284082cbb5d453", "9d773a31fe2ec7", "839d8cfa2c921c3cceb7d1f46bd2eaad706e53f64523d8c0", "4539bb13382b034ddb16a3329148f9243a4eee998fe444aff2870ce198af11f4fb698a67af6c89ad", ""),
            TestFixture(16, "f7079dfa3b5c7b056347d7e437bcded683abd6e2c9e069d333284082cbb5d453", "24b7a65391f88b", "3bed52236182c19418867d468dbf47c8aac46c02445f99bb", "6d0f928352a17d63aca1899cbd305e1f831f1638d27c1e24432704eff9b6830476db3d30d4c103e4", ""),
            TestFixture(16, "f7079dfa3b5c7b056347d7e437bcded683abd6e2c9e069d333284082cbb5d453", "b672c91376f533", "4f7a561e61b7861719e4445057ac9b74a9be953b772b09ec", "f23ac1426cb1130c9a0913b347d8efafb6ed125913aa678a9dc42d22a5436bc12eff5505edb25e19", ""),
            TestFixture(16, "f7079dfa3b5c7b056347d7e437bcded683abd6e2c9e069d333284082cbb5d453", "a6d01fb88ca547", "a36155de477364236591e453008114075b4872120ef17264", "773b8eea2e9830297ac11d3c1f6ea4008c96040e83d76d55789d2043179fdd8fdcbd52313b7b15cb", ""),
            TestFixture(4, "f7079dfa3b5c7b056347d7e437bcded683abd6e2c9e069d333284082cbb5d453", "a544218dadd3c10583db49cf39", "3c0e2815d37d844f7ac240ba9d6e3a0b2a86f706e885959e", "63e00d30e4b08fd2a1cc8d70fab327b2368e77a93be4f4123d14fb3f", ""),
            TestFixture(4, "f7079dfa3b5c7b056347d7e437bcded683abd6e2c9e069d333284082cbb5d453", "1501a243bf60b2cb40d5aa20ca", "f5730a05fec31a11662e2e14e362ccc75c7c30cdfccbf994", "377b2f1e7bd9e3d1077038e084f61950761361095f7eeebbf1a72afc", ""),
            TestFixture(4, "f7079dfa3b5c7b056347d7e437bcded683abd6e2c9e069d333284082cbb5d453", "d65e0e53f765f9d5e6795c0c5e", "20e394c7cc90bdfa6186fc1ba6fff158dfc690e24ba4c9fb", "6cab3060bf3b33b163b933c2ed0ba51406810b54d0edcf5c9d0ef4f7", ""),
            TestFixture(4, "f7079dfa3b5c7b056347d7e437bcded683abd6e2c9e069d333284082cbb5d453", "a6b2371acf8321864c08ddb4d8", "1a43ca628026219c5a430c54021a5a3152ae517167399635", "c5aa500d1f7c09a590e9d15d6860c4433684e04dd6bc5c8f94f223f0", ""),
            TestFixture(4, "f7079dfa3b5c7b056347d7e437bcded683abd6e2c9e069d333284082cbb5d453", "c2b60f14c894ec6178fe79919f", "3e707d98f19972a63d913e6ea7533af2f41ff98aee2b2a36", "852cca903d7fdf899807bd14642057534c8a0ccacb8c7b8fb4d35d44", ""),
            TestFixture(16, "1b0e8df63c57f05d9ac457575ea764524b8610ae5164e6215f426f5a7ae6ede4", "a544218dadd3c10583db49cf39", "3c0e2815d37d844f7ac240ba9d6e3a0b2a86f706e885959e", "f0050ad16392021a3f40207bed3521fb1e9f808f49830c423a578d179902f912f9ea1afbce1120b3", ""),
            TestFixture(16, "1b0e8df63c57f05d9ac457575ea764524b8610ae5164e6215f426f5a7ae6ede4", "1501a243bf60b2cb40d5aa20ca", "f5730a05fec31a11662e2e14e362ccc75c7c30cdfccbf994", "254b847d4175bbb44a82b4e805514fa444c224710933f3ec8aaa3f0133234c0cd91609982adc034b", ""),
            TestFixture(16, "1b0e8df63c57f05d9ac457575ea764524b8610ae5164e6215f426f5a7ae6ede4", "d65e0e53f765f9d5e6795c0c5e", "20e394c7cc90bdfa6186fc1ba6fff158dfc690e24ba4c9fb", "c3618c991b15de641d291419ff6957e8b9ae5046dd8c6f08fafb76adf12f36740347e3edae62bca4", ""),
            TestFixture(16, "1b0e8df63c57f05d9ac457575ea764524b8610ae5164e6215f426f5a7ae6ede4", "a6b2371acf8321864c08ddb4d8", "1a43ca628026219c5a430c54021a5a3152ae517167399635", "bd37326da18e5ac79a1a9512f724bb539530868576b79c67acb5a51d10a58d6584fbe73f1063c31b", ""),
            TestFixture(16, "1b0e8df63c57f05d9ac457575ea764524b8610ae5164e6215f426f5a7ae6ede4", "c2b60f14c894ec6178fe79919f", "3e707d98f19972a63d913e6ea7533af2f41ff98aee2b2a36", "ecd337640022635ce1ed273756d02b7feeb2515614c1fadc95c66d3f411b478853886afd177d88c3", ""),
            TestFixture(4, "1b0e8df63c57f05d9ac457575ea764524b8610ae5164e6215f426f5a7ae6ede4", "a544218dadd3c1", "", "92d00fbe", "d3d5424e20fbec43ae495353ed830271515ab104f8860c988d15b6d36c038eab"),
            TestFixture(4, "1b0e8df63c57f05d9ac457575ea764524b8610ae5164e6215f426f5a7ae6ede4", "3fcb328bc96404", "", "11250056", "10b2ffed4f95af0f98ed4f77c677b5786ad01b31c095bbc6e1c99cf13977abba"),
            TestFixture(4, "1b0e8df63c57f05d9ac457575ea764524b8610ae5164e6215f426f5a7ae6ede4", "c42ac63de6f12a", "", "4eed80fd", "7ff8d06c5abcc50d3820de34b03089e6c5b202bcbaabca892825553d4d30020a"),
            TestFixture(4, "1b0e8df63c57f05d9ac457575ea764524b8610ae5164e6215f426f5a7ae6ede4", "3a1701b185d33a", "", "9a5382c3", "e5d54df8ed9f89b98c5ebb1bc5d5279c2e182784ff4cd9c869ae152e29d7a2b2"),
            TestFixture(4, "1b0e8df63c57f05d9ac457575ea764524b8610ae5164e6215f426f5a7ae6ede4", "4f490ce07e0150", "", "e1842c46", "3e12d09632c644c540077c6f90726d4167423a679322b2000a3f19cfcea02b33"),
            TestFixture(16, "a4bc10b1a62c96d459fbaf3a5aa3face7313bb9e1253e696f96a7a8e36801088", "a544218dadd3c1", "", "93af11a08379eb37a16aa2837f09d69d", "d3d5424e20fbec43ae495353ed830271515ab104f8860c988d15b6d36c038eab"),
            TestFixture(16, "a4bc10b1a62c96d459fbaf3a5aa3face7313bb9e1253e696f96a7a8e36801088", "3fcb328bc96404", "", "b3884b69d117146cfa5529901753ddc0", "10b2ffed4f95af0f98ed4f77c677b5786ad01b31c095bbc6e1c99cf13977abba"),
            TestFixture(16, "a4bc10b1a62c96d459fbaf3a5aa3face7313bb9e1253e696f96a7a8e36801088", "c42ac63de6f12a", "", "b53d93cbfd3d5cf3720cef5080bc7224", "7ff8d06c5abcc50d3820de34b03089e6c5b202bcbaabca892825553d4d30020a"),
            TestFixture(16, "a4bc10b1a62c96d459fbaf3a5aa3face7313bb9e1253e696f96a7a8e36801088", "3a1701b185d33a", "", "0a5d1bc02c5fe096a8b9d94d1267c49a", "e5d54df8ed9f89b98c5ebb1bc5d5279c2e182784ff4cd9c869ae152e29d7a2b2"),
            TestFixture(16, "a4bc10b1a62c96d459fbaf3a5aa3face7313bb9e1253e696f96a7a8e36801088", "4f490ce07e0150", "", "1eda43bf07f2bf003107f3a0ba3a4c18", "3e12d09632c644c540077c6f90726d4167423a679322b2000a3f19cfcea02b33"),
            TestFixture(4, "a4bc10b1a62c96d459fbaf3a5aa3face7313bb9e1253e696f96a7a8e36801088", "a544218dadd3c10583db49cf39", "", "866d4227", "3c0e2815d37d844f7ac240ba9d6e3a0b2a86f706e885959e09a1005e024f6907"),
            TestFixture(4, "a4bc10b1a62c96d459fbaf3a5aa3face7313bb9e1253e696f96a7a8e36801088", "dfdcbdff329f7af70731d8e276", "", "c4ac0952", "2ae56ddde2876d70b3b34eda8c2b1d096c836d5225d53ec460b724b6e16aa5a3"),
            TestFixture(4, "a4bc10b1a62c96d459fbaf3a5aa3face7313bb9e1253e696f96a7a8e36801088", "60f2490ba0c658848859fcbea8", "", "27c3953d", "3ad743283064929bf4fe4e0807f710f5e6a273e22614c728c3280a27b6c614a0"),
            TestFixture(4, "a4bc10b1a62c96d459fbaf3a5aa3face7313bb9e1253e696f96a7a8e36801088", "db113f38f0504615c5c9347c3d", "", "c38fbdff", "3b71bc84e48c6dadf6ead14621d22468a3d4c9c103ac96970269730bcfce239b"),
            TestFixture(4, "a4bc10b1a62c96d459fbaf3a5aa3face7313bb9e1253e696f96a7a8e36801088", "d35f531f714694b5e49303a980", "", "d34e90bb", "55b791ee495299916ff3c2327b4990952bebd0a2da9acfc553c6c996e354a4b5"),
            TestFixture(16, "8c5cf3457ff22228c39c051c4e05ed4093657eb303f859a9d4b0f8be0127d88a", "a544218dadd3c10583db49cf39", "", "867b0d87cf6e0f718200a97b4f6d5ad5", "3c0e2815d37d844f7ac240ba9d6e3a0b2a86f706e885959e09a1005e024f6907"),
            TestFixture(16, "8c5cf3457ff22228c39c051c4e05ed4093657eb303f859a9d4b0f8be0127d88a", "dfdcbdff329f7af70731d8e276", "", "ad879c64425e6c1ec4841bbb0f99aa8b", "2ae56ddde2876d70b3b34eda8c2b1d096c836d5225d53ec460b724b6e16aa5a3"),
            TestFixture(16, "8c5cf3457ff22228c39c051c4e05ed4093657eb303f859a9d4b0f8be0127d88a", "60f2490ba0c658848859fcbea8", "", "e2751f153fc76c0dec5e0cf2d30c1a28", "3ad743283064929bf4fe4e0807f710f5e6a273e22614c728c3280a27b6c614a0"),
            TestFixture(16, "8c5cf3457ff22228c39c051c4e05ed4093657eb303f859a9d4b0f8be0127d88a", "db113f38f0504615c5c9347c3d", "", "fc85464a81fe372c12c9e4f0f3bf9c37", "3b71bc84e48c6dadf6ead14621d22468a3d4c9c103ac96970269730bcfce239b"),
            TestFixture(16, "8c5cf3457ff22228c39c051c4e05ed4093657eb303f859a9d4b0f8be0127d88a", "d35f531f714694b5e49303a980", "", "b1c09b093788da19e33c5a6e82ed9627", "55b791ee495299916ff3c2327b4990952bebd0a2da9acfc553c6c996e354a4b5"),
            TestFixture(4, "8c5cf3457ff22228c39c051c4e05ed4093657eb303f859a9d4b0f8be0127d88a", "a544218dadd3c1", "78c46e3249ca28e1ef0531d80fd37c124d9aecb7be6668e3", "c2fe12658139f5d0dd22cadf2e901695b579302a72fc56083ebc7720", "d3d5424e20fbec43ae495353ed830271515ab104f8860c988d15b6d36c038eab"),
            TestFixture(4, "8c5cf3457ff22228c39c051c4e05ed4093657eb303f859a9d4b0f8be0127d88a", "57b940550a383b", "6fb5ce32a851676753ba3523edc5ca82af1843ffc08f1ef0", "e1b4ec4279bb62902c12521e6b874171695c5da46c647cc03b91ff03", "33c2c3a57bf8393b126982c96d87daeacd5eadad1519073ad8c84cb9b760296f"),
            TestFixture(4, "8c5cf3457ff22228c39c051c4e05ed4093657eb303f859a9d4b0f8be0127d88a", "f32222e9eec4bd", "2c29d4e2bb9294e90cb04ec697e663a1f7385a39f90c8ccf", "224db21beb8cd0069007660e783c3f85706b014128368aab2a4e56a7", "684595e36eda1db5f586941c9f34c9f8d477970d5ccc14632d1f0cec8190ae68"),
            TestFixture(4, "8c5cf3457ff22228c39c051c4e05ed4093657eb303f859a9d4b0f8be0127d88a", "14c9bd561c47c1", "c22524a1ea444be3412b0d773d4ea2ff0af4c1ad2383cba8", "61b46c9024eed3989064a52df90349c18e14e4b552779d3f8f9d6814", "141ae365f8e65ab9196c4e8cd4e62189b304d67de38f2117e84ec0ec8f260ebd"),
            TestFixture(4, "8c5cf3457ff22228c39c051c4e05ed4093657eb303f859a9d4b0f8be0127d88a", "1ccec9923aa6e8", "518a7fb11c463bf23798982118f3cfe4d7ddde9184f37d4f", "52f8205534447d722be2b9377f7395938cc88af081a11ccb0d83fa19", "88a6d037009a1c1756f72bb4589d6d940bd514ed55386baefacc6ac3ca6f8795"),
            TestFixture(16, "705334e30f53dd2f92d190d2c1437c8772f940c55aa35e562214ed45bd458ffe", "a544218dadd3c1", "78c46e3249ca28e1ef0531d80fd37c124d9aecb7be6668e3", "3341168eb8c48468c414347fb08f71d2086f7c2d1bd581ce1ac68bd42f5ec7fa7e068cc0ecd79c2a", "d3d5424e20fbec43ae495353ed830271515ab104f8860c988d15b6d36c038eab"),
            TestFixture(16, "705334e30f53dd2f92d190d2c1437c8772f940c55aa35e562214ed45bd458ffe", "57b940550a383b", "6fb5ce32a851676753ba3523edc5ca82af1843ffc08f1ef0", "fbfed2c94f50ca10466da9903ef85833ad48ca00556e66d14d8b30df941f3536ffb42083ef0e1c30", "33c2c3a57bf8393b126982c96d87daeacd5eadad1519073ad8c84cb9b760296f"),
            TestFixture(16, "705334e30f53dd2f92d190d2c1437c8772f940c55aa35e562214ed45bd458ffe", "f32222e9eec4bd", "2c29d4e2bb9294e90cb04ec697e663a1f7385a39f90c8ccf", "dae13e6967c8b1ee0dd2d5ba1dd1de69f22c95da39528f9ef78e9e5e9faa058112af57f4ac78db2c", "684595e36eda1db5f586941c9f34c9f8d477970d5ccc14632d1f0cec8190ae68"),
            TestFixture(16, "705334e30f53dd2f92d190d2c1437c8772f940c55aa35e562214ed45bd458ffe", "14c9bd561c47c1", "c22524a1ea444be3412b0d773d4ea2ff0af4c1ad2383cba8", "a654238fb8b05e293dba07f9d68d75a7f0fbf40fe20edaeba1586bf922412e73ce338e372615c3bc", "141ae365f8e65ab9196c4e8cd4e62189b304d67de38f2117e84ec0ec8f260ebd"),
            TestFixture(16, "705334e30f53dd2f92d190d2c1437c8772f940c55aa35e562214ed45bd458ffe", "1ccec9923aa6e8", "518a7fb11c463bf23798982118f3cfe4d7ddde9184f37d4f", "765067ef768908d91ee4c3923943e0c7be70e2e06db99a4b3e3f51ee37fdcc5d81dd85d9e9d4f44e", "88a6d037009a1c1756f72bb4589d6d940bd514ed55386baefacc6ac3ca6f8795"),
            TestFixture(4, "705334e30f53dd2f92d190d2c1437c8772f940c55aa35e562214ed45bd458ffe", "a544218dadd3c10583db49cf39", "e8de970f6ee8e80ede933581b5bcf4d837e2b72baa8b00c3", "c0ea400b599561e7905b99262b4565d5c3dc49fad84d7c69ef891339", "3c0e2815d37d844f7ac240ba9d6e3a0b2a86f706e885959e09a1005e024f6907"),
            TestFixture(4, "705334e30f53dd2f92d190d2c1437c8772f940c55aa35e562214ed45bd458ffe", "0dd613c0fe28e913c0edbb8404", "9522fb1f1aa58493cba682d788186d902cfc93e80fd6b998", "fabe11c9629e598228f5209f3dbcc641fe4b1a22cadb0821d2898c3b", "2ad306575b577c2f61da7212ab63e3db3941f1f751f2356c7443531a90b9d141"),
            TestFixture(4, "705334e30f53dd2f92d190d2c1437c8772f940c55aa35e562214ed45bd458ffe", "3e0fe3427eeda80f02dda4fed5", "38333ce78110bf53a2c2abc7db99e133ad218ca43ff7a7bc", "d88f8fcd772125212ce09c2a6e5b5693dd35073f992004f0d18fc889", "ae0d1c9c834d60ff0ecfb3c0d78c72ddb789e58adfc166c81d5fc6395b31ec33"),
            TestFixture(4, "705334e30f53dd2f92d190d2c1437c8772f940c55aa35e562214ed45bd458ffe", "60122cbd219e5cf17415e8bc09", "794e734966e6d0001699aec3f8ab8f194de7653d3091b1b9", "76bdd9a7b34bf14ae121a87fdfa144f71b848744af6a2f0b1c0d067c", "895a45ddbe0c80793eccbf820de13a233b6aa7045cfd5313388e7184c392b216"),
            TestFixture(4, "705334e30f53dd2f92d190d2c1437c8772f940c55aa35e562214ed45bd458ffe", "3542fbe0f59a6d5f3abf619b7d", "c5b3d71312ea14f2f8fae5bd1a453192b6604a45db75c5ed", "617d8036e2039d516709062379e0550cbd71ebb90fea967c79018ad5", "dd4531f158a2fa3bc8a339f770595048f4a42bc1b03f2e824efc6ba4985119d8"),
            TestFixture(16, "314a202f836f9f257e22d8c11757832ae5131d357a72df88f3eff0ffcee0da4e", "a544218dadd3c10583db49cf39", "e8de970f6ee8e80ede933581b5bcf4d837e2b72baa8b00c3", "8d34cdca37ce77be68f65baf3382e31efa693e63f914a781367f30f2eaad8c063ca50795acd90203", "3c0e2815d37d844f7ac240ba9d6e3a0b2a86f706e885959e09a1005e024f6907"),
            TestFixture(16, "314a202f836f9f257e22d8c11757832ae5131d357a72df88f3eff0ffcee0da4e", "0dd613c0fe28e913c0edbb8404", "9522fb1f1aa58493cba682d788186d902cfc93e80fd6b998", "6df09613ea986c2d91a57a45a0942cbf20e0dfca12fbda8c945ee6db24aea5f5098952f1203339ce", "2ad306575b577c2f61da7212ab63e3db3941f1f751f2356c7443531a90b9d141"),
            TestFixture(16, "314a202f836f9f257e22d8c11757832ae5131d357a72df88f3eff0ffcee0da4e", "3e0fe3427eeda80f02dda4fed5", "38333ce78110bf53a2c2abc7db99e133ad218ca43ff7a7bc", "2bfe51f1f43b982d47f76ea8206ddbf585d6f30cec0d4ef16b1556631d3b52bf24154afec1448ef6", "ae0d1c9c834d60ff0ecfb3c0d78c72ddb789e58adfc166c81d5fc6395b31ec33"),
            TestFixture(16, "314a202f836f9f257e22d8c11757832ae5131d357a72df88f3eff0ffcee0da4e", "60122cbd219e5cf17415e8bc09", "794e734966e6d0001699aec3f8ab8f194de7653d3091b1b9", "bf0d219bb50fcc1d51f654bb0fd8b44efa25aef39e2f11afe47d00f2eebb544e6ba7559ac2f34edb", "895a45ddbe0c80793eccbf820de13a233b6aa7045cfd5313388e7184c392b216"),
            TestFixture(16, "314a202f836f9f257e22d8c11757832ae5131d357a72df88f3eff0ffcee0da4e", "3542fbe0f59a6d5f3abf619b7d", "c5b3d71312ea14f2f8fae5bd1a453192b6604a45db75c5ed", "39c2e8f6edfe663b90963b98eb79e2d4f7f28a5053ae8881567a6b4426f1667136bed4a5e32a2bc1", "dd4531f158a2fa3bc8a339f770595048f4a42bc1b03f2e824efc6ba4985119d8")
        ]

        func testEncrypt(fixture: TestFixture) -> Bool {
            let aes = try! AES(key: fixture.key, blockMode: CCM(iv: fixture.nonce, tagLength: fixture.tagLength, messageLength: fixture.plaintext.count, additionalAuthenticatedData: fixture.aad), padding: .noPadding)
            let encrypted = try! aes.encrypt(fixture.plaintext)
            if encrypted != fixture.expected {
                return false
            }
            return true
        }

        for fixture in fixtures {
            XCTAssertTrue(testEncrypt(fixture: fixture))
        }
    }


    func testAESCCMTestCase1() {
        let key: Array<UInt8> =       [0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d, 0x4e, 0x4f];
        let nonce: Array<UInt8> =     [0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16]
        let aad: Array<UInt8> =       [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]
        let plaintext: Array<UInt8> = [0x20, 0x21, 0x22, 0x23]
        let expected: Array<UInt8> =  [0x71, 0x62, 0x01, 0x5b, 0x4d, 0xac, 0x25, 0x5d]

        let aes = try! AES(key: key, blockMode: CCM(iv: nonce, tagLength: 4, messageLength: plaintext.count, additionalAuthenticatedData: aad), padding: .noPadding)
        let encrypted = try! aes.encrypt(plaintext)
        XCTAssertEqual(encrypted, expected, "encryption failed")
    }

    func testAESCCMTestCase1Decrypt() {
        let key: Array<UInt8> =       [0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d, 0x4e, 0x4f];
        let nonce: Array<UInt8> =     [0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16]
        let aad: Array<UInt8> =       [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]
        let ciphertext: Array<UInt8> = [0x71, 0x62, 0x01, 0x5b, 0x4d, 0xac, 0x25, 0x5d]
        let expected: Array<UInt8> = [0x20, 0x21, 0x22, 0x23]

        let aes = try! AES(key: key, blockMode: CCM(iv: nonce, tagLength: 4, messageLength: ciphertext.count - 4, additionalAuthenticatedData: aad), padding: .noPadding)
        let decrypted = try! aes.decrypt(ciphertext)
        XCTAssertEqual(decrypted, expected, "decryption failed")
    }

    func testAESCCMTestCase2() {
        let key: Array<UInt8> =       [0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d, 0x4e, 0x4f];
        let nonce: Array<UInt8> =     [0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17]
        let aad: Array<UInt8> =       [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f]
        let plaintext: Array<UInt8> = [0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2a, 0x2b, 0x2c, 0x2d, 0x2e, 0x2f]
        let expected: Array<UInt8>  = [0xd2, 0xa1, 0xf0, 0xe0, 0x51, 0xea, 0x5f, 0x62, 0x08, 0x1a, 0x77, 0x92, 0x07, 0x3d, 0x59, 0x3d, 0x1f, 0xc6, 0x4f, 0xbf, 0xac, 0xcd]

        let aes = try! AES(key: key, blockMode: CCM(iv: nonce, tagLength: 6, messageLength: plaintext.count, additionalAuthenticatedData: aad), padding: .noPadding)
        let encrypted = try! aes.encrypt(plaintext)
        XCTAssertEqual(encrypted, expected, "encryption failed")
    }

    func testAESCCMTestCase2Decrypt() {
        let key: Array<UInt8> =        [0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d, 0x4e, 0x4f];
        let nonce: Array<UInt8> =      [0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17]
        let aad: Array<UInt8> =        [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f]
        let ciphertext: Array<UInt8> = [0xd2, 0xa1, 0xf0, 0xe0, 0x51, 0xea, 0x5f, 0x62, 0x08, 0x1a, 0x77, 0x92, 0x07, 0x3d, 0x59, 0x3d, 0x1f, 0xc6, 0x4f, 0xbf, 0xac, 0xcd]
        let expected: Array<UInt8>   = [0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2a, 0x2b, 0x2c, 0x2d, 0x2e, 0x2f]

        let aes = try! AES(key: key, blockMode: CCM(iv: nonce, tagLength: 6, messageLength: ciphertext.count - 6, additionalAuthenticatedData: aad), padding: .noPadding)
        let plaintext = try! aes.decrypt(ciphertext)
        XCTAssertEqual(plaintext, expected, "encryption failed")
    }

    func testAESCCMTestCase3() {
        let key: Array<UInt8> =       [0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d, 0x4e, 0x4f];
        let nonce: Array<UInt8> =     [0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b]
        let aad: Array<UInt8> =       [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12, 0x13]
        let plaintext: Array<UInt8> = [0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2a, 0x2b, 0x2c, 0x2d, 0x2e, 0x2f, 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37]
        let expected: Array<UInt8>  = [0xe3, 0xb2, 0x01, 0xa9, 0xf5, 0xb7, 0x1a, 0x7a, 0x9b, 0x1c, 0xea, 0xec, 0xcd, 0x97, 0xe7, 0x0b, 0x61, 0x76, 0xaa, 0xd9, 0xa4, 0x42, 0x8a, 0xa5, 0x48, 0x43, 0x92, 0xfb, 0xc1, 0xb0, 0x99, 0x51]

        let aes = try! AES(key: key, blockMode: CCM(iv: nonce, tagLength: 8, messageLength: plaintext.count, additionalAuthenticatedData: aad), padding: .noPadding)
        let encrypted = try! aes.encrypt(plaintext)
        XCTAssertEqual(encrypted, expected, "encryption failed")
    }

    func testAESCCMTestCase3Decrypt() {
        let key: Array<UInt8> =        [0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d, 0x4e, 0x4f];
        let nonce: Array<UInt8> =      [0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b]
        let aad: Array<UInt8> =        [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12, 0x13]
        let ciphertext: Array<UInt8> = [0xe3, 0xb2, 0x01, 0xa9, 0xf5, 0xb7, 0x1a, 0x7a, 0x9b, 0x1c, 0xea, 0xec, 0xcd, 0x97, 0xe7, 0x0b, 0x61, 0x76, 0xaa, 0xd9, 0xa4, 0x42, 0x8a, 0xa5, 0x48, 0x43, 0x92, 0xfb, 0xc1, 0xb0, 0x99, 0x51]
        let expected: Array<UInt8> =   [0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2a, 0x2b, 0x2c, 0x2d, 0x2e, 0x2f, 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37]

        let aes = try! AES(key: key, blockMode: CCM(iv: nonce, tagLength: 8, messageLength: ciphertext.count - 8, additionalAuthenticatedData: aad), padding: .noPadding)
        let plaintext = try! aes.decrypt(ciphertext)
        XCTAssertEqual(plaintext, expected, "encryption failed")
    }

    func testAESCCMTestCase3DecryptPartial() {
        let key: Array<UInt8> =        [0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d, 0x4e, 0x4f];
        let nonce: Array<UInt8> =      [0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b]
        let aad: Array<UInt8> =        [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12, 0x13]
        let ciphertext: Array<UInt8> = [0xe3, 0xb2, 0x01, 0xa9, 0xf5, 0xb7, 0x1a, 0x7a, 0x9b, 0x1c, 0xea, 0xec, 0xcd, 0x97, 0xe7, 0x0b, 0x61, 0x76, 0xaa, 0xd9, 0xa4, 0x42, 0x8a, 0xa5, 0x48, 0x43, 0x92, 0xfb, 0xc1, 0xb0, 0x99, 0x51]
        let expected: Array<UInt8> =   [0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2a, 0x2b, 0x2c, 0x2d, 0x2e, 0x2f, 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37]

        let aes = try! AES(key: key, blockMode: CCM(iv: nonce, tagLength: 8, messageLength: ciphertext.count - 8, additionalAuthenticatedData: aad), padding: .noPadding)
        var decryptor = try! aes.makeDecryptor()

        var plaintext = [UInt8]()
        plaintext += try! decryptor.update(withBytes: Array(ciphertext[0..<2]))
        plaintext += try! decryptor.update(withBytes: Array(ciphertext[2..<6]))
        plaintext += try! decryptor.update(withBytes: Array(ciphertext[6..<32]), isLast: true)
        XCTAssertEqual(plaintext, expected, "encryption failed")
    }
}
