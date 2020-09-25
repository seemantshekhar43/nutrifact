class OCRText{
  List<Block> blocks;

  OCRText({this.blocks});
}
class Block{
  List<Line> lines;

  Block({this.lines});
}

class Line{
  List<String> elements;

  Line({this.elements});
}