if exists("b:current_syntax")
  finish
endif

syntax match coneTodo "TODO"
syntax match coneNote "NOTE"
syntax match coneXXX "XXX"
syntax match coneFixMe "FIXME"
syntax match coneNoCheckin "NOCHECKIN"
syntax match coneHack "HACK"

" If this changes, change accordingly in :
" syntax match coneTypeSuffix (see below)
syntax keyword coneDataType i8 i16 i32 i64 isize u8 u16 u32 u64 usize f32 f64 dec64 Option Result Bool void Self
" syntax keyword coneDataTypeC contained i8 i16 i32 i64 isize u8 u16 u32 u64 usize f32 f64 dec64 Option Result Bool void

syntax keyword coneTrust trust

syntax keyword conePerm uni mut imm const opaq
syntax keyword coneBool true false
syntax keyword coneNull nil
syntax keyword coneVoid void

syntax match backTick "`"

syntax match coneLibs "\(\<\(include\|import\)\>\s*\)\@<=\(\"\?\)\zs\<\S\{-}\>\ze\3\s*::"
syntax match coneAlias "\(\<as\>\s*\)\@<=\zs\<\S\{-}\>\ze"

" This matches all the names imported from a module if any
" in combination with "contains", "matchgroup" allows to exclude the pattern notConeName
" so that ::, commas, and "as" are not highlighted
syntax match notConeName "\(,\|::\|as\)" contained
syntax region coneName matchgroup=notConeNameLit start="\(::\)\@<=" end="as" contains=notConeName

syntax region coneChar start=/\v'/ skip=/\v\\./ end=/\v'/
syntax region coneString start=/\v"/ skip=/\v\\./ end=/\v"/ contains=coneLibs
syntax region coneRString start=/\vr"/ skip=/\v\\./ end=/\v"/
syntax region coneRawString start=/\vr`/ skip=/\v\\./ end=/\v`/
syntax region cone3String start=/\v"""/ skip=/\v\\./ end=/\v"""/
syntax region coneR3String start=/\vr"""/ skip=/\v\\./ end=/\v"""/

" Detect when we call a function
syntax match coneCallFunction "\(`\?\)\zs\<\S\{-}\>\ze\1\s*("
" syntax match coneCallFunction "\<\S\{-}\>\ze\s*("

" Detect when we call a with the convention that a macro has an upper-case
" first letter
syntax match coneCallMacro "\<\u\S\{-}\>\ze\s*("

" It turns out that we can't match AFTER a keyword with \zs \ze syntax, so
" this fails :
" syntax match coneFunction "\<fn\>\s*\zs\<\S\{-}\>\ze\s*("
" The solution, after spending quite some time understqnding the problem, is
" there :
" see https://vi.stackexchange.com/questions/20747/vim-syntax-match-changes-based-on-function-type-name-keyword
" Which gives this for me (compare to above) :
syntax match coneFunction "\(\<\(fn\|macro\)\>\s*\)\@<=\(`\?\)\zs\<\S\{-}\>\ze\3\s*[(\[]"


"syntax match coneTypeSuffix "\d\zs[df]\ze"
" Same thing here, we avoid colliding with other matches by using @<=, here
" collision with coneInteger
" But it matches any kind of letter and number suffix, whereas I want only the
" types to be recognized...
" syntax match coneTypeSuffix "\(\d\)\@<=\zs\l\d\?\d\?\>\ze"

" That doesn't work either because vim doesn't see keywords inside words :
" 1 i32 : ok
" 1i32  : keyword not seen
" syntax match coneTypeSuffix "\d.*\>" contains=coneDataTypeC
 
" So my solution is to match a list of words :
syntax match coneTypeSuffix "\(\d\)\@<=\zs\(i8\|i16\|i32\|i64\|isize\|u8\|u16\|u32\|u64\|usize\|f32\|f64\|dec64\|f\|d\)\ze"

syntax match coneTagNote "@\<\w\+\>" display

syntax match coneLifetime "'\<\w\+\>" display

syntax match coneRange "\.\.\." display
syntax match coneHalfRange "\.\." display
syntax match coneTernaryQMark "?" display
syntax match coneAssign "=" display
syntax match coneAppendOp "<-" display

syntax match coneDelimBlock "[{}]"
syntax match coneStartBlock "\v\:"
syntax match coneFold "\v\:\:"

syntax match coneLogical "\v\&"
syntax match coneLogical "\v\&&"
syntax match coneLogical "\v\|"
syntax match coneLogical "\v\|\|"
syntax match coneLogical "\v\^"
syntax match coneLogical "\v\~"
syntax match coneLogical "\v\!"

syntax match coneOperator "\v\<"
syntax match coneOperator "\v\>"
syntax match coneOperator "\v\%"
syntax match coneOperator "\v\*"
syntax match coneOperator "\v/"
syntax match coneOperator "\v\+"
syntax match coneOperator "\v-"
syntax match coneOperator "\v\?"
syntax match coneOperator "\v\="
syntax match coneOperator "\v\*\="
syntax match coneOperator "\v/\="
syntax match coneOperator "\v\+\="
syntax match coneOperator "\v-\="
syntax match coneOperator "\v--"
syntax match coneOperator "\v\+\+"
syntax match coneOperator "\v\<\<"
syntax match coneOperator "\v\>\>"
syntax match coneOperator "\v\<\="
syntax match coneOperator "\v\>\="


syntax match coneInteger "\-\?\<\d\+" display
syntax match coneFloat "\-\?\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\%([eE][+-]\=[0-9_]\+\)\=" display
syntax match coneHex "\<0[xX][0-9A-Fa-f]\+\>" display
syntax match coneDoz "\<0[zZ][0-9a-bA-B]\+\>" display
syntax match coneOct "\<0[oO][0-7]\+\>" display
syntax match coneBin "\<0[bB][01]\+\>" display

syntax match coneConstant "\v<[A-Z0-9,_]+\L" display

syntax match coneAddressOf "&" display
syntax match coneDeref "\*" display

syntax match coneMacro "\<macro\>\s*\zs\<\w\{-}\>\ze\s*\[" display

syntax match coneCommentNote "@\<\w\+\>" contained display
syntax region coneLineComment start=/\/\// end=/$/  contains=coneCommentNote, coneTodo, coneNote, coneXXX, coneFixMe, coneNoCheckin, coneHack
syntax region coneBlockComment start=/\v\/\*/ end=/\v\*\// contains=coneBlockComment, coneCommentNote, coneTodo, coneNote, coneXXX, coneFixMe, coneNoCheckin, coneHack

syntax keyword coneSelf self
syntax keyword coneInclude include
syntax keyword coneImport import
syntax keyword coneExtern extern
syntax keyword coneSet set
syntax keyword coneMacro macro
syntax keyword coneFn fn
syntax keyword coneTypeDef typedef
syntax keyword coneStruct struct
syntax keyword coneTrait trait
syntax keyword coneStatic @static
syntax keyword coneSamesize @samesize
syntax keyword coneMove @move
syntax keyword coneOpaque @opaque
syntax keyword coneExtends extends
syntax keyword coneMixin mixin
syntax keyword coneEnum enum
syntax keyword coneRegion region
syntax keyword coneRet return
syntax keyword coneWith with
syntax keyword coneIf if
syntax keyword coneElif elif
syntax keyword coneElse else
syntax keyword coneCase case
syntax keyword coneMatch match
syntax keyword coneLoop loop
syntax keyword coneWhile while
syntax keyword coneEach each
syntax keyword coneIn in
syntax keyword coneBy by
syntax keyword coneBreak break
syntax keyword coneContinue continue
syntax keyword coneNot not
syntax keyword coneOr or
syntax keyword coneAnd and
syntax keyword coneAs as
syntax keyword coneIs is
syntax keyword coneInto into
syntax keyword coneInline inline
syntax keyword coneVoid void
syntax keyword conenil nil
syntax keyword conetrue true
syntax keyword conefalse false

highlight link coneSelf Struct

highlight link coneInclude Keyword
highlight link coneImport Keyword
highlight link coneExtern Keyword
highlight link coneSet Keyword
highlight link coneMacro Keyword
highlight link coneFn Keyword
highlight link coneTypeDef Keyword
highlight link coneTrait Keyword
highlight link coneStatic Keyword
highlight link coneSamesize Keyword
highlight link coneMove Keyword
highlight link coneOpaque Keyword
highlight link coneExtends Keyword
highlight link coneMixin Keyword
highlight link coneEnum Keyword
highlight link coneRegion Keyword
highlight link coneRet Keyword
highlight link coneWith Keyword
highlight link coneIf Keyword
highlight link coneElif Keyword
highlight link coneElse Keyword
highlight link coneCase Keyword
highlight link coneMatch Keyword
highlight link coneLoop Keyword
highlight link coneWhile Keyword
highlight link coneEach Keyword
highlight link coneIn Keyword
highlight link coneBy Keyword
highlight link coneBreak Keyword
highlight link coneContinue Keyword
highlight link coneNot Keyword
highlight link coneOr Keyword
highlight link coneAnd Keyword
highlight link coneAs Keyword
highlight link coneIs Keyword
highlight link coneInto Keyword
highlight link coneInline Keyword
highlight link coneVoid Keyword
highlight link conenil Keyword
highlight link conetrue Keyword
highlight link conefalse Keyword

highlight link coneChar String
highlight link coneString String
highlight link coneRString String
highlight link coneRawString String
highlight link cone3String String
highlight link coneR3String String

highlight link coneLibs Directory
highlight link coneAlias Directory
highlight link coneName Directory
highlight link coneNameLit Normal
highlight link notConeName Normal
highlight link coneFold SpecialKey

highlight link coneLogical Operator
highlight link coneOperator Operator

highlight link coneRange Operator
highlight link coneHalfRange Operator
highlight link coneAddressOf Operator
highlight link coneDeref Operator

highlight link coneAssign Operator
highlight link coneTernaryQMark Operator
highlight link coneAppendOp Operator

highlight link coneStruct Structure
highlight link coneEnum Structure
highlight link coneUnion Structure
highlight link coneBitField Structure
highlight link coneBitSet Structure

highlight link coneFunction Function

highlight link coneMacro Macro
highlight link coneIf Conditional
highlight link coneWhen Conditional
highlight link coneElse Conditional
highlight link coneFor Repeat

highlight link coneLineComment Comment
highlight link coneBlockComment Comment
highlight link coneCommentNote Todo

highlight link coneTodo Todo
highlight link coneNote Todo
highlight link coneXXX Todo
highlight link coneFixMe Todo
highlight link coneNoCheckin Todo
highlight link coneHack Todo

highlight link coneTagNote Identifier
highlight link coneTypeSuffix Type
highlight link coneDataType Type
highlight link conePerm WarningMsg
highlight link coneTrust WarningMsg

" highlight link coneDataTypeC Type
highlight link coneBool Boolean
highlight link coneConstant Constant
highlight link coneNull Type
highlight link coneInteger Number
highlight link coneFloat Float
highlight link coneHex Number
highlight link coneOct Number
highlight link coneBin Number
highlight link coneDoz Number


"""
""" OPTIONS : uncomment these highlighting possibilities as desired
"""

""  Calling a macro will me highlighted if you use the convention of defining a Macro with an uppercase first letter
highlight link coneCallMacro Macro

""  Calling a function will be highlighted
highlight link coneCallFunction Function

""  Change the way the logical operators are highlighted : if you uncomment
""  this next line, it will overrule conelOgical highlighting defined
""  here-before
" highlight link coneLogical Question

""  Here, we choose specific color curly braces and backticks
""  and colons. Comment it out if not enjoyed !
highlight link backTick MoreMsg
highlight link coneDelimBlock NonText
highlight link coneStartBlock NonText

"""
"""
"""

let b:current_syntax = "cone"
