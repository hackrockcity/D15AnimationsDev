// Unit
class LED {
  PVector position;  // Position of LED
  color c;           // The color

  LED(PVector position) {
    this.position = position;
    c = color(0);
  }
  
  void set(color c) {
    this.c = c;
  }
}

// LEDList or Strip or Channel
class LEDList extends ArrayList<LED> {
}

// StripList of ChannelList
class LEDSegmentsList extends ArrayList<LEDList> {
}

// ChannelStripList or ChannelSegmentsList
class ChannelSegmentsList extends ArrayList<LEDSegmentsList> {
}