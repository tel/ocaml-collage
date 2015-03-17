
module Value = Value

module Prop = struct
  type t = string

  let equal x y = x = y
  let compare x y = String.compare x y

  let of_string s = s
  let to_string s = s

  let accept_ = "accept"
  let accept_charset_ = "accept-charset"
  let accesskey_ = "accesskey"
  let action_ = "action"
  let alt_ = "alt"
  let async_ = "async"
  let autocomplete_ = "autocomplete"
  let autofocus_ = "autofocus"
  let autoplay_ = "autoplay"
  let challenge_ = "challenge"
  let charset_ = "charset"
  let checked_ = "checked"
  let cite_ = "cite"
  let class_ = "class"
  let cols_ = "cols"
  let colspan_ = "colspan"
  let content_ = "content"
  let contenteditable_ = "contenteditable"
  let contextmenu_ = "contextmenu"
  let controls_ = "controls"
  let coords_ = "coords"
  let data_ = "data"
  let datetime_ = "datetime"
  let defer_ = "defer"
  let dir_ = "dir"
  let disabled_ = "disabled"
  let draggable_ = "draggable"
  let enctype_ = "enctype"
  let for_ = "for"
  let form_ = "form"
  let formaction_ = "formaction"
  let formenctype_ = "formenctype"
  let formmethod_ = "formmethod"
  let formnovalidate_ = "formnovalidate"
  let formtarget_ = "formtarget"
  let headers_ = "headers"
  let height_ = "height"
  let hidden_ = "hidden"
  let high_ = "high"
  let href_ = "href"
  let hreflang_ = "hreflang"
  let httpEquiv_ = "httpEquiv"
  let icon_ = "icon"
  let id_ = "id"
  let ismap_ = "ismap"
  let item_ = "item"
  let itemprop_ = "itemprop"
  let keytype_ = "keytype"
  let label_ = "label"
  let lang_ = "lang"
  let list_ = "list"
  let loop_ = "loop"
  let low_ = "low"
  let manifest_ = "manifest"
  let max_ = "max"
  let maxlength_ = "maxlength"
  let media_ = "media"
  let method_ = "method"
  let min_ = "min"
  let multiple_ = "multiple"
  let name_ = "name"
  let novalidate_ = "novalidate"
  let onbeforeonload_ = "onbeforeonload"
  let onbeforeprint_ = "onbeforeprint"
  let onblur_ = "onblur"
  let oncanplay_ = "oncanplay"
  let oncanplaythrough_ = "oncanplaythrough"
  let onchange_ = "onchange"
  let onclick_ = "onclick"
  let oncontextmenu_ = "oncontextmenu"
  let ondblclick_ = "ondblclick"
  let ondrag_ = "ondrag"
  let ondragend_ = "ondragend"
  let ondragenter_ = "ondragenter"
  let ondragleave_ = "ondragleave"
  let ondragover_ = "ondragover"
  let ondragstart_ = "ondragstart"
  let ondrop_ = "ondrop"
  let ondurationchange_ = "ondurationchange"
  let onemptied_ = "onemptied"
  let onended_ = "onended"
  let onerror_ = "onerror"
  let onfocus_ = "onfocus"
  let onformchange_ = "onformchange"
  let onforminput_ = "onforminput"
  let onhaschange_ = "onhaschange"
  let oninput_ = "oninput"
  let oninvalid_ = "oninvalid"
  let onkeydown_ = "onkeydown"
  let onkeyup_ = "onkeyup"
  let onload_ = "onload"
  let onloadeddata_ = "onloadeddata"
  let onloadedmetadata_ = "onloadedmetadata"
  let onloadstart_ = "onloadstart"
  let onmessage_ = "onmessage"
  let onmousedown_ = "onmousedown"
  let onmousemove_ = "onmousemove"
  let onmouseout_ = "onmouseout"
  let onmouseover_ = "onmouseover"
  let onmouseup_ = "onmouseup"
  let onmousewheel_ = "onmousewheel"
  let ononline_ = "ononline"
  let onpagehide_ = "onpagehide"
  let onpageshow_ = "onpageshow"
  let onpause_ = "onpause"
  let onplay_ = "onplay"
  let onplaying_ = "onplaying"
  let onprogress_ = "onprogress"
  let onpropstate_ = "onpropstate"
  let onratechange_ = "onratechange"
  let onreadystatechange_ = "onreadystatechange"
  let onredo_ = "onredo"
  let onresize_ = "onresize"
  let onscroll_ = "onscroll"
  let onseeked_ = "onseeked"
  let onseeking_ = "onseeking"
  let onselect_ = "onselect"
  let onstalled_ = "onstalled"
  let onstorage_ = "onstorage"
  let onsubmit_ = "onsubmit"
  let onsuspend_ = "onsuspend"
  let ontimeupdate_ = "ontimeupdate"
  let onundo_ = "onundo"
  let onunload_ = "onunload"
  let onvolumechange_ = "onvolumechange"
  let onwaiting_ = "onwaiting"
  let open_ = "open"
  let optimum_ = "optimum"
  let pattern_ = "pattern"
  let ping_ = "ping"
  let placeholder_ = "placeholder"
  let preload_ = "preload"
  let pubdate_ = "pubdate"
  let radiogroup_ = "radiogroup"
  let readonly_ = "readonly"
  let rel_ = "rel"
  let required_ = "required"
  let reversed_ = "reversed"
  let rows_ = "rows"
  let rowspan_ = "rowspan"
  let sandbox_ = "sandbox"
  let scope_ = "scope"
  let scoped_ = "scoped"
  let seamless_ = "seamless"
  let selected_ = "selected"
  let shape_ = "shape"
  let size_ = "size"
  let sizes_ = "sizes"
  let span_ = "span"
  let spellcheck_ = "spellcheck"
  let src_ = "src"
  let srcdoc_ = "srcdoc"
  let start_ = "start"
  let step_ = "step"
  let style_ = "style"
  let subject_ = "subject"
  let summary_ = "summary"
  let tabindex_ = "tabindex"
  let target_ = "target"
  let title_ = "title"
  let type_ = "type"
  let usemap_ = "usemap"
  let value_ = "value"
  let width_ = "width"
  let wrap_ = "wrap"
  let xmlns_ = "xmlns"

end

module Cap = struct
  type t =
    { prop  : Prop.t
    ; value : Value.t
    }
  let mk prop value = {prop; value}
  let mk_bare prop = {prop; value = `Empty}
  let fold f {prop; value} = f prop value
  let prop {prop} = prop
  let value {value} = value
  let compare x y = Prop.compare x.prop y.prop
end

module Cs = Types.FixedMap.Make (struct
    type k = Prop.t
    type v = Value.t

    let compare = Prop.compare
  end)

include Cs

let omap f = function
  | None -> None
  | Some a -> Some (f a)

let to_buf s =
  let module F = FoldMap (Buf) in
  let fold prop value =
    let b x = Buf.of_string x in
    let p x = b @@ Prop.to_string x in
    let v x = omap b @@ Value.to_string x in
    let ( ^ ) = Buf.mult in
    p prop ^ begin
      match v value with
      | None   -> Buf.unit
      | Some a -> b "=\"" ^ a ^ b "\""
    end ^ b " "
  in F.fold_map fold s

let to_string x = Buf.to_string (to_buf x)
