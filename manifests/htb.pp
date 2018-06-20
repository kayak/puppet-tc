# === Define tc::htb ===
# Applies HTB discipline to the specified (as namevar) interface.
#
# NOTE! Only outbound traffic can be shaped. Consider this writing filters.
#
# === Parameters ===
# [*handle*]
#   Root handle id which is later reffered as parent in classes.
#   Default: 1 (equivalent to 1:0)
#
# [*default*]
#   Class id which is used by discipline by default (if no filters matchs given packet).
#   This class must be defined in $classes.
#
# [*bandwith*]
#   Full bandwith of the interface. This rate is applied to the root class of discipline.
#   Default: 1000Mbit
#
# [*burst*]
#   Buffer size of the root class. See explanation at https://www.opennet.ru/base/net/htb_manual.txt.html
#   This burst value should be greater (or eqaul) than burst values of child classes.
#
# [*classes*]
#   Hash declaring the list of classes and their settings. The settings include rate, ceil, burst.
#   Hash keys are the numbers used as class id (parent_id:class_id).
#   * rate  = bandwidth dedicate for this class
#   * ceil  = maximum bandwidth which can be allowed for the class if the whole bandwidth has excess.
#   * burst = buffer size, maximum queue lenght that can be served before switching to other classes.
#
# [*filters*]
#   Hash declaring rules which packets to which classes would be assigned.
#   Hash keys can be anything since they are not used in templates. For bravity it's recommended to name
#   them the same as flow id.
#   * prio  = priority of the filter
#   * src   = src IP address
#   * dst   = destination IP address.
#   * sport = source port
#   * dport = destination port
#   * flow  = class id to which the packet will be assigned.
#
define tc::htb (
  Integer $handle      = 1,
  Integer $default,
  String  $bandwidth   = '1000Mbit',
  String  $burst       = '15k',
  Hash[Integer, Struct[{
    rate  => String[1],
    ceil  => Optional[String[1]],
    burst => Optional[String[1]]
  }]]     $classes,
  Hash[Integer, Struct[{
    prio  => Integer,
    src   => Optional[Stdlib::Ipv4],
    dst   => Optional[Stdlib::Ipv4],
    sport => Optional[Stdlib::Port],
    dport => Optional[Stdlib::Port],
    flow  => Integer
  }]]     $filters,
) {

  include ::tc

  $ifname = $name

  concat::fragment { "tc-htb-for-${ifname}":
    target  => $::tc::script,
    content => template("${module_name}/htb.erb"),
    order   => '02',
  }
}
