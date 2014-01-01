module JvmOptsHelper
  def self.gen_heap_opts(total_mem_str)
    if total_mem_str  =~ /(\d+)/
      total_mem = $1.to_i

      divided_mem = total_mem / 3

      # others = zookeeper and jmxtrans. Max mem we'll give them is 256MB
      upper_bound_mem_for_others = 2 * 256 * 1024    
      mem_for_others = (divided_mem * 2 < upper_bound_mem_for_others)? divided_mem * 2 : upper_bound_mem_for_others

      mem = total_mem - mem_for_others
      return "-Xmx#{mem}k -Xms#{mem}k"
    end
  end
end
