class ClipBoard
  include Singleton
  extend Forwardable
  
  attr_reader :clip

  def_delegators :clip, :each

  def initialize
    @clip = []
  end

  def add_to(object)
    @clip << object
  end

  def get_from
    @clip.pop
  end

  def destroy
    @clip = []
  end
end
