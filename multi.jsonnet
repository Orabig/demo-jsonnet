
// jsonnet -m out/ multi.jsonnet

local dyn(x=10,y=20,z=30) =
    {
        title: "Titre pour x=%d y=%d z=%d" % [x,y,z],
        x: x,
        y: y,
        z: z
    };

{
  "a.json": dyn(),
  "b.json": dyn(123,77),
  "c.json": dyn(50) + { contenu: "supplémentaire"},
}