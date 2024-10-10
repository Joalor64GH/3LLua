/*
 * Copyright (C)2008-2017 Haxe Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */
package hlua;

enum Const {
	CInt( v : Int );
	CFloat( f : Float );
	CString( s : String , ?interpolated:Bool);
	#if !haxe3
	CInt32( v : haxe.Int32 );
	#end
}

typedef Expr = {
	var expr : ExprDef;
	var pmin : Int;
	var pmax : Int;
	var origin : String;
	var line : Int;
}

enum ExprDef {
	EEnd;
	EConst( c : Const );
	EIdent( v : String );
	ELocal( n : String , ?e : Expr );
	EParent( e : Expr );
	EBlock( e : Array<Expr> );
	EField( e : Expr, f : String );
	EBinop( op : String, e1 : Expr, e2 : Expr );
	EUnop( op : String, prefix : Bool, e : Expr );
	ECall( e : Expr, params : Array<Expr> );
	ECallSugar( e : Expr , params : Array<Expr> , ?field : String );
	EIf( cond : Expr, e1 : Expr, ?e2 : Array<Expr> , ?e3:Expr );
	EElseIf( cond : Expr , e1 : Expr , e2 : Expr );
	EWhile( cond : Expr, e : Array<Expr> );
	ERepeatUntil( cond : Expr, e : Array<Expr> );
	ENumericFor( v : String, vl : Expr , min : Expr , max : Expr , e : Array<Expr> );
	EGenericFor( v: String , it : Expr , e : Array<Expr> );
	EBreak;
	EContinue;
	EFunction( args : Array<String>, e : Expr, ?name : String );
	EReturn( ?e : Expr );
	EArray( e : Expr, index : Expr );
	EArrayDecl( e : Array<Expr> );
	ENew( cl : String, params : Array<Expr> );
	EThrow( e : Expr );
	ETry( e : Expr, v : String, t : Null<CType>, ecatch : Expr );
	EObject( fl : Array<{ name : String, e : Expr }> );
	ETernary( cond : Expr, e1 : Expr, e2 : Expr );
	ESwitch( e : Expr, cases : Array<{ values : Array<Expr>, expr : Expr , ifExpr : Expr }>, ?defaultExpr : Expr);
	EMeta( name : String, args : Array<Expr>, e : Expr );
	ECheckType( e : Expr, t : CType );
}

typedef Metadata = Array<{ name : String, params : Array<Expr> }>;

enum CType {
	CTPath( path : Array<String>, ?params : Array<CType> );
	CTFun( args : Array<CType>, ret : CType );
	CTAnon( fields : Array<{ name : String, t : CType, ?meta : Metadata }> );
	CTParent( t : CType );
	CTOpt( t : CType );
	CTNamed( n : String, t : CType );
}

class Error {
	public var e : ErrorDef;
	public var pmin : Int;
	public var pmax : Int;
	public var origin : String;
	public var line : Int;
	public function new(e, pmin, pmax, origin, line) {
		this.e = e;
		this.pmin = pmin;
		this.pmax = pmax;
		this.origin = origin;
		this.line = line;
	}
	public function toString(): String {
		return Printer.errorToString(this);
	}
}

enum ErrorDef {
	EInvalidChar( c : Int );
	EUnexpected( s : String );
	EUnterminatedString( s : String );
	EUnterminatedLongString( l : Int );
	EUnterminatedComment;
	EInvalidPreprocessor( msg : String );
	EUnknownVariable( v : String );
	EInvalidIterator( v : String );
	EInvalidOp( op : String );
	EInvalidAccess( f : String );
	ECustom( msg : String );
}
