import java.util.Arrays;
import java.util.concurrent.RecursiveTask;
/*
PP-2
Lab6 . Java. Monitor. Fork/Join
Kobylynskiy Dmytro IP-31
20.04.16
 */
public class DotProduct extends RecursiveTask<Integer> {

    private Vector A, B;
    private static int minSize;

    public DotProduct(Vector A, Vector B) {
        this.A = A;
        this.B = B;
    }

    public DotProduct(Vector A, Vector B, int minSize) {
        this.A = A;
        this.B = B;
        DotProduct.minSize = minSize;
    }

    @Override
    protected Integer compute() {
        int res = 0;
        if (A.size() != minSize) {
            Vector childOfA1 = new Vector(A.size() / 2);
            Vector childOfA2 = new Vector(A.size() / 2);
            Vector childOfB1 = new Vector(B.size() / 2);
            Vector childOfB2 = new Vector(B.size() / 2);

            for (int i = 0; i < childOfA1.size(); i++) {
                childOfA1.set(i, A.get(i));
                childOfA2.set(i, A.get(childOfA1.size() + i));
                childOfB1.set(i, B.get(i));
                childOfB2.set(i, B.get(childOfB1.size() + i));
            }

            DotProduct child1 = new DotProduct(childOfA1, childOfB1);
            child1.fork();
            DotProduct child2 = new DotProduct(childOfA2, childOfB2);
            child2.fork();
            System.out.println(Arrays.toString(childOfA1.array));
            System.out.println(childOfA1.size());
            System.out.println(Arrays.toString(childOfA2.array));
            res += child1.join();
            res += child2.join();

        } else {
            for (int i = 0; i < A.size(); i++) {
                res += A.get(i) * B.get(i);
            }
        }
        return res;
    }
}
