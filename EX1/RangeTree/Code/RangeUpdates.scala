import scala.math.{max, min}
class RangeTreeException extends RuntimeException

abstract class Tree {
  def update(i: Int, j: Int, c: Int)
  def query(i: Int): Int
  def sum(i: Int, j: Int): Int
  def getInterval: (Int, Int)
}

object TreeHelper {
  def joinInterval(n1: Tree, n2: Tree): (Int, Int) = (n1.getInterval._1, n2.getInterval._2)
  def intersect(i: Int, j: Int, tree: Tree): Option[(Int, Int)] = {
    val result = (max(i, tree.getInterval._1), min(j, tree.getInterval._2))
    if (result._1 <= result._2) Some(result) else None
  }
  def createTree(n: Int): Tree = {
    def aux(current: IndexedSeq[Tree]): Tree = {
      if (current.size == 1) current(0)
      else {
        val branches = (0 until (current.size / 2)).map(_*2).map(x => new Branch(joinInterval(current(x), current(x+1)), 0, 0, current(x), current(x+1)))
        if (current.size % 2 == 0) aux(branches)
        else aux(branches :+ current(current.size - 1))
      }
    }
    aux((0 until n).map(new Leaf(_, 0)))
  }
}

class Branch(val interval: (Int, Int), var toChildren: Int, var totalChildren: Int, val left: Tree, val right: Tree) extends Tree {
  override def update(i: Int, j: Int, c: Int): Unit = {
    def updateChildren(child: Tree) = TreeHelper.intersect(i, j, child).foreach(o => child.update(o._1, o._2, c))
    (i, j) match {
      case this.interval => totalChildren += (j - i + 1) * c; toChildren += c
      case _             => totalChildren += (j - i + 1) * c; updateChildren(this.left); updateChildren(this.right)
    }
  }
  override def query(i: Int): Int = {
    TreeHelper.intersect(i, i, left).map(o => this.left.query(i)).sum +
      TreeHelper.intersect(i, i, right).map(o => this.right.query(i)).sum + this.toChildren
  }
  override def sum(i: Int, j: Int): Int = {
    def sumChildren(child: Tree) = TreeHelper.intersect(i, j, child).map(o => child.sum(o._1, o._2)).sum
    (i, j) match {
      case this.interval => totalChildren
      case _             => toChildren * (j - i + 1) + sumChildren(this.left) + sumChildren(this.right)
    }
  }
  override def getInterval: (Int, Int) = interval
}

class Leaf(val label: Int, var value: Int) extends Tree {
  override def update(i: Int, j: Int, c: Int): Unit = if (i <= label && label <= j) value += c else throw new RangeTreeException
  override def query(i: Int): Int = if (label == i) value else throw new RangeTreeException
  override def sum(i: Int, j: Int): Int = if (i <= label && label <= j) value else throw new RangeTreeException
  override def getInterval: (Int, Int) = (label, label)
}

object Main extends App {
  override def main(args: Array[String]): Unit = {
    val tree = TreeHelper.createTree(10)
    tree.update(1, 8, 9)
    tree.update(3, 8, 1)
    println(tree.query(8))
    println(tree.sum(1, 8))
  }
}