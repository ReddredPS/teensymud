#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.9
# from Racc grammer file "".
#

require 'racc/parser.rb'

#
# file::    farts_parser.rb
# author::  Jon A. Lambert
# version:: 2.8.0
# date::    01/19/2006
#
# This source code copyright (C) 2005, 2006 by Jon A. Lambert
# All rights reserved.
#
# Released under the terms of the TeensyMUD Public License
# See LICENSE file for additional information.
#
$:.unshift "lib" if !$:.include? "lib"
$:.unshift "vendor" if !$:.include? "vendor"

if $0 == __FILE__
  Dir.chdir("../..")
  $:.unshift "../../lib"
end
require 'farts/farts_lexer'
require 'farts/farts_lib'

module Farts
  class Parser < Racc::Parser

module_eval(<<'...end farts_parser.y/module_eval...', 'farts_parser.y', 109)

  def initialize
    @scope = {}
  end

  def parse( str )
    @sc = Farts::Lexer.new(str)
    @yydebug = true if $DEBUG              
    do_parse
  end

  def next_token
    @sc.next_token
  end

  def on_error( t, val, values )
    raise Racc::ParseError, "Error: #{@sc.lineno}:#{@sc.tokenpos} syntax error at '#{val}'"
  end

...end farts_parser.y/module_eval...
##### State transition tables begin ###

racc_action_table = [
    12,    26,    27,    28,    29,    24,    25,    30,    31,    26,
    27,    28,    29,    24,    25,    12,    35,    19,    13,    55,
    14,    17,    18,    20,     8,    21,    22,     9,    10,    37,
    12,    11,    19,    13,    58,    14,    17,    18,    20,     8,
    21,    22,     9,    10,    12,    57,    11,    19,    13,    42,
    14,    17,    18,    20,    41,    21,    22,    12,    32,    33,
    35,    19,    13,    61,    14,    17,    18,    20,    12,    21,
    22,    62,    56,    35,    19,    13,    63,    14,    17,    18,
    20,    12,    21,    22,    35,    19,    13,    43,    14,    17,
    18,    20,    12,    21,    22,    36,    37,    35,    19,    13,
    23,    14,    17,    18,    20,    12,    21,    22,    35,    19,
    13,     3,    14,    17,    18,    20,    12,    21,    22,   nil,
   nil,    35,    19,    13,   nil,    14,    17,    18,    20,    12,
    21,    22,    35,    19,    13,   nil,    14,    17,    18,    20,
    12,    21,    22,   nil,   nil,    35,    19,    13,   nil,    14,
    17,    18,    20,    12,    21,    22,    35,    19,    13,   nil,
    14,    17,    18,    20,    12,    21,    22,   nil,   nil,    35,
    19,    13,   nil,    14,    17,    18,    20,    12,    21,    22,
    35,    19,    13,   nil,    14,    17,    18,    20,    12,    21,
    22,   nil,   nil,    35,    19,    13,   nil,    14,    17,    18,
    20,   nil,    21,    22,    35,    19,    13,    12,    14,    17,
    18,    20,   nil,    21,    22,   nil,     8,   nil,   nil,     9,
    10,   nil,    60,    11,    19,    13,   nil,    14,    17,    18,
    20,   nil,    21,    22,    26,    27,    28,    29,    24,    25,
    30,    31,    26,    27,    28,    29,    24,    25,    30,    31,
    26,    27,    28,    29,    24,    25,    30,    31,    26,    27,
    28,    29,    24,    25,    30,    31,    26,    27,    28,    29,
    24,    25,    30,    26,    27,    28,    29,   -42,   -42,    26,
    27,    28,    29,   -42,   -42,   -42,   -42,   -42,   -42,   -42,
   -42,   -42,   -42,   -42,   -42,   -42,   -42,   -42,   -42,   -42,
   -42 ]

racc_action_check = [
    37,    39,    39,    39,    39,    39,    39,    39,    39,    50,
    50,    50,    50,    50,    50,     2,    37,    37,    37,    39,
    37,    37,    37,    37,     2,    37,    37,     2,     2,    35,
    64,     2,     2,     2,    43,     2,     2,     2,     2,    64,
     2,     2,    64,    64,    31,    42,    64,    64,    64,    21,
    64,    64,    64,    64,    20,    64,    64,    62,     8,     8,
    31,    31,    31,    54,    31,    31,    31,    31,    10,    31,
    31,    54,    41,    62,    62,    62,    59,    62,    62,    62,
    62,    30,    62,    62,    10,    10,    10,    22,    10,    10,
    10,    10,    12,    10,    10,    11,    11,    30,    30,    30,
     3,    30,    30,    30,    30,    13,    30,    30,    12,    12,
    12,     1,    12,    12,    12,    12,    14,    12,    12,   nil,
   nil,    13,    13,    13,   nil,    13,    13,    13,    13,    29,
    13,    13,    14,    14,    14,   nil,    14,    14,    14,    14,
    27,    14,    14,   nil,   nil,    29,    29,    29,   nil,    29,
    29,    29,    29,    28,    29,    29,    27,    27,    27,   nil,
    27,    27,    27,    27,    24,    27,    27,   nil,   nil,    28,
    28,    28,   nil,    28,    28,    28,    28,    25,    28,    28,
    24,    24,    24,   nil,    24,    24,    24,    24,    26,    24,
    24,   nil,   nil,    25,    25,    25,   nil,    25,    25,    25,
    25,   nil,    25,    25,    26,    26,    26,    52,    26,    26,
    26,    26,   nil,    26,    26,   nil,    52,   nil,   nil,    52,
    52,   nil,    52,    52,    52,    52,   nil,    52,    52,    52,
    52,   nil,    52,    52,    53,    53,    53,    53,    53,    53,
    53,    53,     5,     5,     5,     5,     5,     5,     5,     5,
    65,    65,    65,    65,    65,    65,    65,    65,    34,    34,
    34,    34,    34,    34,    34,    34,    51,    51,    51,    51,
    51,    51,    51,    45,    45,    45,    45,    45,    45,    44,
    44,    44,    44,    44,    44,    49,    49,    49,    49,    48,
    48,    48,    48,    47,    47,    47,    47,    46,    46,    46,
    46 ]

racc_action_pointer = [
   nil,   111,    12,   100,   nil,   238,   nil,   nil,    45,   nil,
    65,    75,    89,   102,   113,   nil,   nil,   nil,   nil,   nil,
    27,    22,    60,   nil,   161,   174,   185,   137,   150,   126,
    78,    41,   nil,   nil,   254,     8,   nil,    -3,   nil,    -3,
   nil,    53,    26,    15,   275,   269,   293,   289,   285,   281,
     5,   262,   204,   230,    41,   nil,   nil,   nil,   nil,    59,
   nil,   nil,    54,   nil,    27,   246 ]

racc_action_default = [
    -2,   -42,    -1,   -42,    -3,    -4,    -5,    -6,    -7,   -10,
   -42,   -14,   -42,   -42,   -42,   -27,   -28,   -29,   -30,   -31,
   -32,   -34,   -36,    66,   -42,   -42,   -42,   -42,   -42,   -42,
   -42,   -42,    -8,    -9,    -2,   -42,   -15,   -39,   -16,   -42,
   -26,   -42,   -42,   -42,   -17,   -18,   -19,   -20,   -21,   -22,
   -23,   -24,   -13,   -40,   -42,   -25,   -33,   -35,   -37,   -42,
    -2,   -38,   -42,   -11,   -12,   -41 ]

racc_goto_table = [
     2,    34,     1,    38,    39,    40,    59,    54,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,    44,    45,    46,    47,    48,
    49,    50,    51,   nil,   nil,   nil,   nil,   nil,    53,   nil,
   nil,   nil,   nil,   nil,    52,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,    65,   nil,   nil,   nil,   nil,   nil,   nil,
    64 ]

racc_goto_check = [
     2,     4,     1,     4,     4,     4,     7,    10,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,     4,     4,     4,     4,     4,
     4,     4,     4,   nil,   nil,   nil,   nil,   nil,     4,   nil,
   nil,   nil,   nil,   nil,     2,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,     4,   nil,   nil,   nil,   nil,   nil,   nil,
     2 ]

racc_goto_pointer = [
   nil,     2,     0,   nil,    -9,   nil,   nil,   -46,   nil,   nil,
   -30 ]

racc_goto_default = [
   nil,   nil,   nil,     4,     5,     6,     7,   nil,    15,    16,
   nil ]

racc_reduce_table = [
  0, 0, :racc_error,
  1, 32, :_reduce_1,
  0, 33, :_reduce_2,
  2, 33, :_reduce_3,
  1, 34, :_reduce_none,
  1, 34, :_reduce_none,
  1, 34, :_reduce_none,
  1, 34, :_reduce_7,
  2, 34, :_reduce_8,
  2, 34, :_reduce_9,
  1, 34, :_reduce_10,
  5, 37, :_reduce_11,
  2, 38, :_reduce_12,
  0, 38, :_reduce_13,
  1, 36, :_reduce_14,
  2, 36, :_reduce_15,
  2, 35, :_reduce_16,
  3, 35, :_reduce_17,
  3, 35, :_reduce_18,
  3, 35, :_reduce_19,
  3, 35, :_reduce_20,
  3, 35, :_reduce_21,
  3, 35, :_reduce_22,
  3, 35, :_reduce_23,
  3, 35, :_reduce_24,
  3, 35, :_reduce_none,
  2, 35, :_reduce_none,
  1, 35, :_reduce_none,
  1, 35, :_reduce_none,
  1, 40, :_reduce_29,
  1, 40, :_reduce_30,
  1, 40, :_reduce_31,
  1, 40, :_reduce_32,
  3, 40, :_reduce_33,
  1, 40, :_reduce_34,
  3, 40, :_reduce_35,
  1, 40, :_reduce_36,
  3, 40, :_reduce_37,
  4, 39, :_reduce_38,
  0, 41, :_reduce_none,
  1, 41, :_reduce_40,
  3, 41, :_reduce_41 ]

racc_reduce_n = 42

racc_shift_n = 66

racc_token_table = {
  false => 0,
  :error => 1,
  :UMINUS => 2,
  :NOT => 3,
  :GT => 4,
  :GE => 5,
  :LT => 6,
  :LE => 7,
  :EQ => 8,
  :NE => 9,
  :AND => 10,
  :OR => 11,
  :END => 12,
  :TRUE => 13,
  :FALSE => 14,
  :COMMENT => 15,
  :IF => 16,
  :ENDIF => 17,
  :ELSE => 18,
  :ID => 19,
  :STRING => 20,
  :LPAREN => 21,
  :RPAREN => 22,
  :SUB => 23,
  :NUMBER => 24,
  :FLOAT => 25,
  :ACTOR => 26,
  :SEND => 27,
  :THIS => 28,
  :ARGS => 29,
  :COMMA => 30 }

racc_nt_base = 31

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "UMINUS",
  "NOT",
  "GT",
  "GE",
  "LT",
  "LE",
  "EQ",
  "NE",
  "AND",
  "OR",
  "END",
  "TRUE",
  "FALSE",
  "COMMENT",
  "IF",
  "ENDIF",
  "ELSE",
  "ID",
  "STRING",
  "LPAREN",
  "RPAREN",
  "SUB",
  "NUMBER",
  "FLOAT",
  "ACTOR",
  "SEND",
  "THIS",
  "ARGS",
  "COMMA",
  "$start",
  "program",
  "stmts",
  "stmt",
  "expr",
  "command",
  "if",
  "else",
  "function",
  "atom",
  "args" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

module_eval(<<'.,.,', 'farts_parser.y', 27)
  def _reduce_1(val, _values, result)
      result = ProgramSyntaxNode.new( @sc.lineno, val[0] ) 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 30)
  def _reduce_2(val, _values, result)
     result = [] 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 32)
  def _reduce_3(val, _values, result)
     result.push val[1] 
    result
  end
.,.,

# reduce 4 omitted

# reduce 5 omitted

# reduce 6 omitted

module_eval(<<'.,.,', 'farts_parser.y', 37)
  def _reduce_7(val, _values, result)
     result = EndSyntaxNode.new( @sc.lineno, true) 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 38)
  def _reduce_8(val, _values, result)
     result = EndSyntaxNode.new( @sc.lineno, true) 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 39)
  def _reduce_9(val, _values, result)
     result = EndSyntaxNode.new( @sc.lineno, false) 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 40)
  def _reduce_10(val, _values, result)
     result = CommentSyntaxNode.new( @sc.lineno, val[0]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 43)
  def _reduce_11(val, _values, result)
     result = IfSyntaxNode.new( @sc.lineno, val[1], val[2], val[3] ) 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 45)
  def _reduce_12(val, _values, result)
     result = val[1] 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 46)
  def _reduce_13(val, _values, result)
     result = nil 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 48)
  def _reduce_14(val, _values, result)
     result = CommandSyntaxNode.new( @sc.lineno, val[0] , nil ) 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 49)
  def _reduce_15(val, _values, result)
     result = CommandSyntaxNode.new( @sc.lineno, val[0], val[1] ) 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 51)
  def _reduce_16(val, _values, result)
     result = CallSyntaxNode.new( @sc.lineno, '!', [val[1]] ) 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 52)
  def _reduce_17(val, _values, result)
     result = CallSyntaxNode.new( @sc.lineno, '==', [val[0], val[2]] ) 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 53)
  def _reduce_18(val, _values, result)
     result = CallSyntaxNode.new( @sc.lineno, '!=', [val[0], val[2]] ) 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 54)
  def _reduce_19(val, _values, result)
     result = CallSyntaxNode.new( @sc.lineno, '>', [val[0], val[2]] ) 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 55)
  def _reduce_20(val, _values, result)
     result = CallSyntaxNode.new( @sc.lineno, '>=', [val[0], val[2]] ) 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 56)
  def _reduce_21(val, _values, result)
     result = CallSyntaxNode.new( @sc.lineno, '<', [val[0], val[2]] ) 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 57)
  def _reduce_22(val, _values, result)
     result = CallSyntaxNode.new( @sc.lineno, '<=', [val[0], val[2]] ) 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 58)
  def _reduce_23(val, _values, result)
     result = CallSyntaxNode.new( @sc.lineno, '&&', [val[0], val[2]] ) 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 59)
  def _reduce_24(val, _values, result)
     result = CallSyntaxNode.new( @sc.lineno, '||', [val[0], val[2]] ) 
    result
  end
.,.,

# reduce 25 omitted

# reduce 26 omitted

# reduce 27 omitted

# reduce 28 omitted

module_eval(<<'.,.,', 'farts_parser.y', 65)
  def _reduce_29(val, _values, result)
     result = LiteralSyntaxNode.new( @sc.lineno, val[0] ) 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 66)
  def _reduce_30(val, _values, result)
     result = LiteralSyntaxNode.new( @sc.lineno, val[0] ) 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 67)
  def _reduce_31(val, _values, result)
     result = LiteralSyntaxNode.new( @sc.lineno, val[0] ) 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 68)
  def _reduce_32(val, _values, result)
     result = [LocalVarSyntaxNode.new( @sc.lineno, val[0] )] 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 69)
  def _reduce_33(val, _values, result)
     result = [AttributeSyntaxNode.new( @sc.lineno, val[0], val[2])] 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 70)
  def _reduce_34(val, _values, result)
     result = LocalVarSyntaxNode.new( @sc.lineno, val[0] ) 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 71)
  def _reduce_35(val, _values, result)
     result = AttributeSyntaxNode.new( @sc.lineno, val[0], val[2] ) 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 72)
  def _reduce_36(val, _values, result)
     result = LocalVarSyntaxNode.new( @sc.lineno, val[0] ) 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 73)
  def _reduce_37(val, _values, result)
     result = AttributeSyntaxNode.new( @sc.lineno, val[0], val[2] ) 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 76)
  def _reduce_38(val, _values, result)
     result = CallSyntaxNode.new( @sc.lineno, val[0], *val[2] ) 
    result
  end
.,.,

# reduce 39 omitted

module_eval(<<'.,.,', 'farts_parser.y', 79)
  def _reduce_40(val, _values, result)
     result = [val] 
    result
  end
.,.,

module_eval(<<'.,.,', 'farts_parser.y', 80)
  def _reduce_41(val, _values, result)
     result.push(val[2]) 
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

  end   # class Parser
  end   # module Farts



module Farts

  class SyntaxNode
    attr :lineno

    def initialize( lineno )
      @lineno = lineno
    end

    def exec_list(intp, nodes)
      v = nil
      nodes.each do |i|
        v = i.execute(intp)
        break if intp.hitbreak == true
      end
      v
    end

    def fart_err(msg)
      raise "Error at #{lineno}: #{msg}"
    end
  end

  class ProgramSyntaxNode < SyntaxNode

    def initialize( lineno, tree )
      super lineno
      @tree = tree
    end

    def execute(vars)
      intp = Interpreter.new(vars)
      exec_list(intp, @tree)
    end
  end

  class EndSyntaxNode < SyntaxNode

    def initialize( lineno, val )
      super lineno
      @val = val
    end

    def execute(intp)
      intp.hitbreak = true
      intp.retval = val
    end
  end

  class CommentSyntaxNode < SyntaxNode

    def initialize( lineno, val )
      super lineno
      @val = val
    end

    def execute(intp)
    end
  end

  class CallSyntaxNode < SyntaxNode

    def initialize( lineno, func, args )
      super lineno
      @funcname = func
      @args = args
    end

    def execute(intp)
      arg = @args.collect {|i| i.execute(intp) }
      begin
        case @funcname
        when "||"
          arg[0] || arg[1]
        when "&&"
          arg[0] && arg[1]
        when "!="
          arg[0] != arg[1]
        when "!"
          !arg[0]
        else
          if arg.empty? || !arg[0].respond_to?(@funcname)
            intp.call_lib_function(@funcname, arg) do
              fart_err("undefined function '#{@funcname}'")
            end
          else
            recv = arg.shift
            recv.send(@funcname, *arg)
          end
        end
      rescue ArgumentError
        pp self
        pp arg
        fart_err($!.message)
      end
    end
  end

  class CommandSyntaxNode < SyntaxNode

    def initialize( lineno, cmd, args )
      super lineno
      @cmd = cmd
      @args = args
    end

    def execute(intp)
      begin
        if @args
          intp.vars["this"].parse(@cmd + " " + @args)
        else
          intp.vars["this"].parse(@cmd)
        end
      rescue Exception
        pp self
        fart_err($!.message)
      end
    end
  end

  class IfSyntaxNode < SyntaxNode

    def initialize( lineno, condition, stmts_true, stmts_false )
      super lineno
      @condition = condition
      @stmts_true = stmts_true
      @stmts_false = stmts_false
    end

    def execute(intp)
      if @condition.execute(intp)
        exec_list(intp, @stmts_true)
      else
        exec_list(intp, @stmts_false) if @stmts_false
      end
    end
  end

  class LocalVarSyntaxNode < SyntaxNode

    def initialize( lineno, vname )
      super lineno
      @vname = vname
    end

    def execute( intp )
      if intp.vars.has_key?(@vname)
        intp.vars[@vname]
      else
        fart_err("unknown local variable '#{@vname}'")
      end
    end
  end

  class AttributeSyntaxNode < SyntaxNode

    def initialize( lineno, vname, vattr )
      super lineno
      @vname = vname
      @vattr = vattr
    end

    def execute(intp)
      begin
      if intp.vars.has_key?(@vname)
          intp.vars[@vname].send(@vattr.intern)
        else
          fart_err("unknown local variable '#{@vname}'")
        end
      rescue NameError
        fart_err($!.message)
      end
    end
  end

  class LiteralSyntaxNode < SyntaxNode

    def initialize( lineno, val )
      super lineno
      @val = val
    end

    def execute( intp )
      @val.class == String ? @val.dup : @val
    end
  end

  # The Interpreter class is an instance of a machine to execute a program
  class Interpreter
    attr_accessor :hitbreak, :retval, :vars

    # Construct an interpreter machine
    # [+vars+] A hash table of attribute name/value pairs.
    #   Currently we support 'actor' and 'this', where they are the first
    #   two parameters of an event respectively.
    def initialize(vars)
      @vars = vars  # hash table of attribute_name/value pairs
      @hitbreak = false
      @retval = true
      @lib = Lib.new
    end

    def call_lib_function( fname, args )
      if @lib.respond_to?(fname)
        @lib.send(fname, *args)
      else
        yield
      end
    end

  end

end


#
# FARTS testing
#
if $0 == __FILE__
  require 'pp'
  begin
    fart = nil
    str =""
    File.open('farts/myprog.fart') {|f|
      str = f.read
    }
    fart = Farts::Parser.new.parse( str )
    pp fart
    vars = { "actor" => "foo", "this" => "bar"}
    fart.execute(vars)
    
  rescue Racc::ParseError, Exception
    log.error $!
    exit 
  end
end
