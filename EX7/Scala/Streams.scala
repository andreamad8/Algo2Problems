import org.scalacheck.Prop.forAll
import org.scalacheck.Properties
import org.scalacheck.Gen
import scala.util.Random

object Streams extends Properties("Streams") {
  val nBy2Lists: Gen[List[Int]] = for {
    size <- Gen.posNum[Int]
    rest <- Gen.listOfN[Int](size / 2, Gen.posNum[Int])
  } yield Random.shuffle(List.fill(size / 2 + 1)(0) ++ rest)

  property("maxFreq") = forAll(nBy2Lists) { l => l.groupBy (identity).mapValues (_.size).maxBy (_._2)._1 == MaxFreq.maxElement(l) }
}
