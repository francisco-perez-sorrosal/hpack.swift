import Spectre
import hpack


func testTable() {
  describe("HeaderTable") {
    let table = HeaderTable()

    $0.describe("subscripting") {
      $0.it("returns nil for invalid entry") {
        try expect(table[0]).to.beNil()
        try expect(table[62]).to.beNil()
        try expect(table[100]).to.beNil()
      }

      $0.it("can lookup for static entries") {
        let authority = table[1]
        try expect(authority?.name) == ":authority"
        try expect(authority?.value) == ""

        let method = table[2]
        try expect(method?.name) == ":method"
        try expect(method?.value) == "GET"

        let authenticate = table[61]
        try expect(authenticate?.name) == "www-authenticate"
        try expect(authenticate?.value) == ""
      }
    }

    $0.describe("searching") {
      $0.it("can search for static entry") {
        let index = table.search(name: ":method", value: "GET")
        try expect(index) == 2
      }

      $0.it("can search for static entry matching name") {
        let index = table.search(name: ":method")
        try expect(index) == 2
      }
    }

    $0.describe("adding") {
      var table = HeaderTable()
      table.add(name: "custom-header", value: "custom-value")

      $0.it("allows you to search for added header") {
        try expect(table.search(name: "custom-header", value: "custom-value")) == 62
      }

      $0.it("allows you to search for added header matching name") {
        try expect(table.search(name: "custom-header")) == 62
      }

      $0.it("allows you to subscript added header") {
        try expect(table[62]?.name) == "custom-header"
        try expect(table[63]).to.beNil()
      }
    }
  }
}
