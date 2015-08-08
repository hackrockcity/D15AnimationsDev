package moonpaper;

public final class Patchable<T> {
	public T t;

	public Patchable(T t_) {
		t = t_;
	}

	public void set(T t_) {
		t = t_;
	}

	public Patchable<T> get() {
		return new Patchable<T>(t);
	}

	public T value() {
		return t;
	}
}
