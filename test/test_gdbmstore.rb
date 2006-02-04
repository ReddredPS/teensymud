# Code Generated by ZenTest v. 2.3.0

unless defined? $ZENTEST and $ZENTEST
require 'test/unit'
require 'flexmock'
require 'pp'
class Engine
  @@mock = FlexMock.new
  @@mock.mock_handle(:db) {$db}
  @@mock.mock_handle(:getid) {$id += 1}
  def self.instance
    @@mock
  end
end

require 'utility/configuration'
require 'storage/gdbmstore'
require 'core/world'
require 'core/player'
require 'core/room'
end

class TestGdbmStore < Test::Unit::TestCase
  configuration

  def setup
    $id = 0
    @db = GdbmStore.new(options['dbfile'])
    $db = @db
    @r = Room.new("Here",0)
    @o = GameObject.new("Thing",0)
    @p = Player.new("Tyche", "tyche", nil)
  end

  def teardown
    @db.close
    File.delete("#{options['dbfile']}.gdbm")
  end

  def test_delete
#    pp @r, @o, @p
#    pp @db
    assert_equal(@r, @db.put(@r))
    assert_equal(@o, @db.put(@o))
    @db.delete(@r.id)
    @db.delete(@o.id)
    assert_equal(nil, @db.get(@r.id))
    assert_equal(nil, @db.get(@o.id))
    assert_equal(nil, @db.get(@p.id))
  end

  def test_close
    assert_respond_to(@db, :close)
  end

  def test_log
    assert_respond_to(@db, :log)
  end

  def test_makenoswap
    assert(@db.makenoswap(@r.id))
  end

  def test_makeswap
    assert(@db.makeswap(@r.id))
  end

  def test_get
#    pp @r, @o, @p
    assert_equal(@r, @db.put(@r))
    assert_equal(@o, @db.put(@o))
    assert_equal(@r.id, @db.get(@r.id).id)
    assert_equal(@o.id, @db.get(@o.id).id)
    assert_equal(nil, @db.get(@p.id))
  end

  def test_check
#    pp @r, @o, @p
    assert(!@db.check(@r.id))
  end

  def test_mark
#    pp @r, @o, @p
    assert(@db.mark(@r.id))
  end

  def test_getid
    assert_equal(5,@db.getid)
  end

  def test_each
    assert_equal(@r, @db.put(@r))
    assert_equal(@o, @db.put(@o))
    assert_equal(@p, @db.put(@p))
    cnt = 0
    @db.each {cnt += 1}
    assert_equal(5,cnt)
  end

  def test_put
    assert_equal(@r, @db.put(@r))
    assert_equal(@o, @db.put(@o))
    assert_equal(@p, @db.put(@p))
  end

  def test_save
    assert(@db.save)
  end

=begin
# These be hit and miss as the cache code is too variable
  def test_stats
    assert_equal(@r, @db.put(@r))
    assert_equal(@o, @db.put(@o))
    assert_equal(@p, @db.put(@p))
    assert(@db.save)
    @db.get(@r.id)
    @db.get(99)
    stats=<<EOH
[COLOR=cyan]
---* Database Statistics *---
  Rooms   - 2
  Players - 1
  Objects - 1
  Total Objects - 4
  Highest OID in use - 4
---*                     *---
[/COLOR]
----------* Cache Statistics *----------
cache marks               : 25
cache size                : 161
database read fails       : 1
cache mark misses         : 25
database reads            : 1
reads                     : 6
cache syncs               : 1
database writes           : 3
writes                    : 3
cache read hits           : 4
----------*                  *----------
EOH
    assert_equal(stats,@db.stats)
  end
=end

end

