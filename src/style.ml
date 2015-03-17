
module Value = Stringlike.Simple

module Prop = struct
  type t = string

  let equal x y = x = y
  let compare x y = String.compare x y

  let of_string s = s
  let to_string s = s

  let font_ = "font"
  let font_family_ = "font-family"
  let font_size_ = "font-size"
  let font_weight_ = "font-weight"
  let font_style_ = "font-style"
  let font_variant_ = "font-variant"
  let line_height_ = "line-height"
  let letter_spacing_ = "letter-spacing"
  let word_spacing_ = "word-spacing"
  let text_align_ = "text-align"
  let text_decoration_ = "text-decoration"
  let text_indent_ = "text-indent"
  let text_transform_ = "text-transform"
  let vertical_align_ = "vertical-align"
  let white_space_ = "white-space"

  let color_ = "color"
  let background_color_ = "background-color"
  let background_ = "background"
  let background_image_ = "background-image"
  let background_repeat_ = "background-repeat"
  let background_position_ = "background-position"
  let background_attachment_ = "background-attachment"

  let padding_ = "padding"
  let padding_top_ = "padding-top"
  let padding_right_ = "padding-right"
  let padding_bottom_ = "padding-bottom"
  let padding_left_ = "padding-left"
  let border_ = "border"
  let border_top_ = "border-top"
  let border_right_ = "border-right"
  let border_bottom_ = "border-bottom"
  let border_left_ = "border-left"
  let border_style_ = "border-style"
  let border_top_style_ = "border-top-style"
  let border_right_style_ = "border-right-style"
  let border_bottom_style_ = "border-bottom-style"
  let border_left_style_ = "border-left-style"
  let border_color_ = "border-color"
  let border_top_color_ = "border-top-color"
  let border_right_color_ = "border-right-color"
  let border_bottom_color_ = "border-bottom-color"
  let border_left_color_ = "border-left-color"
  let border_width_ = "border-width"
  let border_top_width_ = "border-top-width"
  let border_right_width_ = "border-right-width"
  let border_bottom_width_ = "border-bottom-width"
  let border_left_width_ = "border-left-width"
  let outline_ = "outline"
  let outline_style_ = "outline-style"
  let outline_color_ = "outline-color"
  let outline_width_ = "outline-width"
  let margin_ = "margin"
  let margin_top_ = "margin-top"
  let margin_right_ = "margin-right"
  let margin_bottom_ = "margin-bottom"
  let margin_left_ = "margin-left"
  let width_ = "width"
  let height_ = "height"
  let min_width_ = "min-width"
  let max_width_ = "max-width"
  let min_height_ = "min-height"
  let max_height_ = "max-height"

  let position_ = "position"
  let top_ = "top"
  let right_ = "right"
  let bottom_ = "bottom"
  let left_ = "left"
  let clip_ = "clip"
  let overflow_ = "overflow"
  let z_index_ = "z-index"
  let float_ = "float"
  let clear_ = "clear"
  let display_ = "display"
  let visibility_ = "visibility"

  let list_style_ = "list-style"
  let list_style_type_ = "list-style-type"
  let list_style_image_ = "list-style-image"
  let list_style_position_ = "list-style-position"

  let table_layout_ = "table_layout"
  let border_collapse_ = "border-collapse"
  let border_spacing_ = "border-spacing"
  let empty_cells_ = "empty-cells"
  let caption_side_ = "caption-side"

  let content_ = "content"
  let counter_increment = "counter-incremen"
  let counter_reset_ = "counter-reset"
  let quotes_ = "quotes"

  let page_break_before_ = "page-break-before"
  let page_break_after_ = "page-break-after"
  let page_break_inside_ = "page-break-inside"
  let orphans_ = "orphans"
  let widows_ = "widows"

  let cursor_ = "cursor"
  let direction_ = "direction"
  let unicode_bidi_ = "unicode-bidi"

end

module Cap = struct
  type t =
    { prop  : Prop.t
    ; value : Value.t
    }
  let mk prop value = {prop; value}
  let mk_bare prop = {prop; value = Value.of_string ""}
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

let to_buf s =
  let module F = FoldMap (Buf) in
  let fold prop value =
    let b x = Buf.of_string x in
    let p x = b @@ Prop.to_string x in
    let v x = b @@ Value.to_string x in
    let ( ^ ) = Buf.mult in
    p prop ^ b ": " ^ v value ^ b "; "
  in F.fold_map fold s

let to_string x = Buf.to_string (to_buf x)
