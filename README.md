# puppet-tc
Helper to create and run a script containing tc commands.
Currently HTB discipline is implemented.

## Installation
Clone into puppet's modules directory:
```
git clone https://github.com/efoft/puppet-tc.git tc
```

## Example of usage
To apply traffic shaper on ens160:
```
tc::htb { 'ens160':
  bandwidth => '1000Mbit',
  default   => 10,
  burst     => '15k',
  classes   => lookup('tc.classes'),
  filters   => lookup('tc.filters', Hash, 'deep'),
}
```
While hiera data is:
```
tc:
  classes:
    10:
      rate: '10Mbit'
    20:
      rate: '256Kbit'
      burst: '15k'
  filters:
    20:
      prio: 2
      dst: 10.1.1.100/32
      dport: 80
      flow: 20
```
