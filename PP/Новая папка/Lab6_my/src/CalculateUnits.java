import java.util.concurrent.ForkJoinPool;
/*
PP-2
Lab6 . Java. Monitor. Fork/Join
Kobylynskiy Dmytro IP-31
20.04.16
 */
public class CalculateUnits{
    private Vector A, B;
    public CalculateUnits(Vector A , Vector B){
        this.A = A;
        this.B = B;
    }
    public Integer splitParts(){
        ForkJoinPool forkJoinPool = new ForkJoinPool(A.size());
        int res = 0;
        Vector childOfA1 = new Vector(A.size() / 3);
        Vector childOfA2 = new Vector(A.size() / 3);
        Vector childOfA3 = new Vector(A.size() / 3);
        Vector childOfB1 = new Vector(B.size() / 3);
        Vector childOfB2 = new Vector(B.size() / 3);
        Vector childOfB3 = new Vector(B.size() / 3);
        childOfA1.fill(1);childOfA2.fill(1);childOfA3.fill(1);
        childOfB1.fill(1);childOfB2.fill(1);childOfB3.fill(1);

        res+=forkJoinPool.invoke(new DotProduct(childOfA1, childOfB1, 1));
        res+=forkJoinPool.invoke(new DotProduct(childOfA2, childOfB2, 1));
        res+=forkJoinPool.invoke(new DotProduct(childOfA3, childOfB3, 1));

        return res;
    }
}