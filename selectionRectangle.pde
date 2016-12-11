/**
 * SelectionRectangle for Processing 3
 * by Debbie Carne.
 *
 * Model a rectangle that can be drawn corner to corner with the mouse.
 *
 * requires a function called from draw() that will paint the rectangle. e.g.
 *
 * void renderSelection() {
 *   if ( selectionRect.hasRectangle() ){
 *     // get rect corners and render the rect.
 *     PVector topLeft = selectionRect.getTopLeft();
 *     PVector bottomRight = selectionRect.getBottomRight();
 *
 *     rectMode(CORNERS);
 *     fill(255, 255, 255, 50);
 *     //strokeWeight(2);
 *     stroke(255, 255, 255, 80);
 *     rect(topLeft.x, topLeft.y, bottomRight.x, bottomRight.y);
 *   }
 * }
 */
class SelectionRectangle {
  PVector mTopLeft = new PVector();
  PVector mBottomRight = new PVector();
  boolean mHasRectangle = false; // we start empty
  boolean mIsInDrawingState = false;
  float WHRatio = 1;

  void startDrawingAt(float xx, float yy) {
    mTopLeft.set(xx, yy);
    mBottomRight.set(xx,yy);
    mIsInDrawingState = true;
    mHasRectangle = true;
  }

  void updateBottomRight(float xx, float yy) {
    if ( ! isInDrawingState() ) {
      throw new RuntimeException("You can only call updateBottomRight() after calling startDrawingRectAt(). Model currently is not in drawing state");
    }
    mBottomRight.set(xx, yy);
  }

  boolean isInDrawingState() {
    return mIsInDrawingState;
  }

  void finishDrawing() {
    mIsInDrawingState = false;
    mHasRectangle = false;
  }

  PVector getTopLeft(){
    return mTopLeft;
  }


  PVector getBottomRight() {
    return mBottomRight;
  }

  boolean hasRectangle() {
    return mHasRectangle;
  }

  float width() {
    // dist(x1, y1, x2, y2)
    // TL mTopLeft.x, mTopLeft.y        TR mBottomRight.x, mTopLeft.y
    // BL mTopLeft.x, mBottomRight.y    BR mBottomRight.x, mBottomRight.y
    return dist(mTopLeft.x, mTopLeft.y, mBottomRight.x, mTopLeft.y);
  }

  float height() {
    return dist(mTopLeft.x, mTopLeft.y, mTopLeft.x, mBottomRight.y);
  }
}
