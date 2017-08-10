// q pubsub.q -p 5001
.z.ws:{value -9!x}
// table and upd definitions
trade:flip `time`sym`price`size!"nsfi"$\:()
quote:flip `time`sym`bid`ask!"nsff"$\:()
upd:insert
// subs table to keep track of current subscriptions
subs:2!flip `handle`func`params`curData!"is**"$\:()
// pubsub functions
sub:{`subs upsert (.z.w;x;y;res:eval(x;enlist y));(x;res)}
pub:{neg[x] -8!y}
pubsub:{pub[.z.w] eval(sub[x];enlist y)}
.z.pc: {delete from `subs where handle=x}
// functions to be called through WebSocket
loadPage:{pubsub[;`$x]each `getSyms`getQuotes`getTrades}
filterSyms:{pubsub[;`$x]each `getQuotes`getTrades}
// get data methods
getData:{
 w:$[all all null y;();enlist(in;`sym;enlist y)];
 0!?[x;w;enlist[`sym]!enlist`sym;()]
 }
getQuotes:{getData[`quote] x}
getTrades:{getData[`trade] x}
getSyms:{distinct (quote`sym),trade`sym}
// refresh function - publishes data if changes exist, and updates subs
refresh:{
 update curData:{[h;f;p;c]
 if[not c~d:eval(f;enlist p);pub[h] (f;d)]; d
 }'[handle;func;params;curData] from `subs
 }
// trigger refresh every 100ms
.z.ts:{refresh[]}
\t 100
