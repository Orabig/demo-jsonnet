local params = {
    name: "Un super titre",
    page: 1,
    num_page: 10,
    width: 600,
    margin: 50,
    content : $.width - $.margin * 2
};

{
  title: "%(name)s - p %(page)d/%(num_page)d" % params,
  x1: params.margin,
  x2: params.width - params.margin
}