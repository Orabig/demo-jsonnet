local sum(x=20, y=10) = x + y;

local fibbo(x) =
  if x <= 1 then [ 1 ]
  else if x == 2 then [ 1, 1 ]
  else
    local ary = fibbo( x-1 );
    local len = std.length(ary);
    ary + [ ary[len-2] + ary[len-1] ];

local samples = { 

    answer: sum(y=22),

    fibonacci: fibbo(6),

    filename: std.thisFile,

    value: {a:30, b:[40, 50]},

};

samples + {

    value: 20,

    yaml: std.manifestYamlDoc( samples,
            indent_array_in_object=false)

}