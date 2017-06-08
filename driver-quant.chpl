use Time;
use Random;
use quantile;

proc randfill(data, sz) {
  //var r = new RandomStream(int, sz);
  //r.fill(data);
  fillRandom(data);
  return data;
}

proc hf(x:int, y:int) :int {
  if x == y {
    return 0;
  }
  else if x < y {
    return -1;
  }

  return 1;
}

proc main() {

  var sketch = new QuantileSketch(int, hf, 1014);

  var dataDom = {0..100000};
  var data : [dataDom] int;
  fillRandom(data);

  var numOps = 0;

  var time_constraint = true;
  var FIVE_MINUTES = 5.0;
  var aggregatetime = 0.0;

  while( time_constraint ) {

    data = randfill(data, dataDom.high);
    var timer = new Timer();
    timer.start();
    for i in data {
      sketch.update(i);
    }
    timer.stop();

    aggregatetime += timer.elapsed(); //(ops_stop - ops_start);
    numOps+=1;
    var m = (aggregatetime/60.0);
    var s = (((aggregatetime-60.0)*(aggregatetime/60.0)));
    //writeln( (m,s) );

    time_constraint = (m <= FIVE_MINUTES);
    //writeln(numOps, (m,s), time_constraint, aggregatetime);
  }

  writeln((numOps, aggregatetime));
}
