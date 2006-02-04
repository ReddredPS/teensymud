# Code Generated by ZenTest v. 2.3.0
#                 classname: asrt / meth =  ratio%
#             ProtocolStack:   26 /    4 = 650.00%

unless defined? $ZENTEST and $ZENTEST
require 'test/unit'
require 'network/protocol/protocolstack'
require 'flexmock'
end

class TestProtocolStack < Test::Unit::TestCase
  def setup
    @serv = FlexMock.new
    @serv.mock_handle(:service_io) { :sockio }
    @serv.mock_handle(:service_filters) { [:telnetfilter, :debugfilter] }
    @serv.mock_handle(:service_negotiation) { [:supga, :zmp, :echo] }
    @conn = FlexMock.new
    @conn.mock_handle(:server) {@serv}
    @ps = ProtocolStack.new(@conn)
  end

  def test_binary_on
    assert_equal(false, @ps.binary_on)
  end

  def test_binary_on_equals
    assert_equal(true, @ps.binary_on = true)
  end

  def test_color_on
    assert_equal(false, @ps.color_on)
  end

  def test_color_on_equals
    assert_equal(true, @ps.color_on = true)
  end

  def test_conn
    assert_respond_to(@ps, :conn)
  end

  def test_echo_on
    assert_equal(false, @ps.echo_on)
  end

  def test_echo_on_equals
    assert_equal(true, @ps.echo_on = true)
  end

  def test_filter_call
    assert_equal("hiya", @ps.filter_call(:filter_in, "hiya"))
  end

  def test_hide_on
    assert_equal(false, @ps.hide_on)
  end

  def test_hide_on_equals
    assert_equal(true, @ps.hide_on = true)
  end

  def test_query
    assert_equal([80,23], @ps.query(:termsize))
  end

  def test_set
    assert(true, @ps.set(:termsize, [120,5] ))
    assert_equal([120,5], @ps.query(:termsize))
    assert(true, @ps.set(:terminal, "ansi"))
    assert_equal("ansi", @ps.query(:terminal))
  end

  def test_terminal
    assert_equal(nil, @ps.terminal)
  end

  def test_terminal_equals
    assert_equal("vt100", @ps.terminal = "vt100")
  end

  def test_theight
    assert_equal(23, @ps.theight)
  end

  def test_theight_equals
    assert_equal(53, @ps.theight = 53)
  end

  def test_twidth
    assert_equal(80, @ps.twidth)
  end

  def test_twidth_equals
    assert_equal(100, @ps.twidth = 100)
  end

  def test_urgent_on
    assert_equal(false, @ps.urgent_on)
  end

  def test_urgent_on_equals
    assert_equal(true, @ps.urgent_on = true)
  end

  def test_zmp_on
    assert_equal(false, @ps.zmp_on)
  end

  def test_zmp_on_equals
    assert_equal(true, @ps.zmp_on = true)
  end
end
