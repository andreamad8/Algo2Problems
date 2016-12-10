object MaxFreq {
  def maxElement(stream: List[Int]) = {
    def aux(s: List[Int], current: Int, times: Int): Int = {
      s match {
        case Nil => current
        case x :: xs if x == current => aux(xs, current, times + 1)
        case x :: xs if times > 0 => aux(xs, current, times - 1)
        case x :: xs => aux(xs, x, 1)
      }
    }
    aux(stream, -1, 0)
  }
}
