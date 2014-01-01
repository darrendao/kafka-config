module JvmOptsHelper
  def self.gen_heap_opts(total_mem_str)
    if total_mem_str  =~ /(\d+)/
      total_mem = $1.to_i
    
      # We're reserving 256m to run zookeeper and another 256m for jmxtrans 
      mem = total_mem - 256 * 1024 - 256 * 1024 
      return "-Xmx#{mem}k -Xms#{mem}k"
    end
  end
end
