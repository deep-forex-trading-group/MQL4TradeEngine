/// @file   ChessTest.mq4
/// @author Copyright 2017, Eneset Group Trust
/// @brief  MQLUNIT examples : ChessTest class definition.

//-----------------------------------------------------------------------------
// Copyright 2017, Eneset Group Trust
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//-----------------------------------------------------------------------------

#property strict

#ifndef SCRIPTS_MQLUNIT_EXAMPLES_CHESS_CHESSTEST_MQH
#define SCRIPTS_MQLUNIT_EXAMPLES_CHESS_CHESSTEST_MQH

#include <ThirdPartyLib/MQLUNITLib/MQLUNIT/MQLUNIT.mqh>
#include <ThirdPartyLib/MQLUNITLib/MQLLIB//Lang/Pointer.mqh>

//-----------------------------------------------------------------------------

template <typename T>
class MQLUNIT_Examples_Chess_ChessTest
    : public MQLUNIT_Examples_Chess_BoardGameTest<T> {
public:
    MQLUNIT_Examples_Chess_ChessTest()
        : MQLUNIT_Examples_Chess_BoardGameTest<T>(typename(this))  {};
    MQLUNIT_Examples_Chess_ChessTest(string name)
        : MQLUNIT_Examples_Chess_BoardGameTest<T>(name) {};

    MQLUNIT_START
    MQLUNIT_INHERIT(MQLUNIT_Examples_Chess_BoardGameTest<T>)

    //----------------------------------------

    TEST_START(NumberOfPieces){
        ASSERT_TRUE("", _game.getNumberOfPieces() == 32);
    }
    TEST_END

    //----------------------------------------

    MQLUNIT_END
};

//-----------------------------------------------------------------------------

#endif
