package mindmaps.importexport {
	import collections.TreeCollectionEx;

	import org.hamcrest.assertThat;
	import org.hamcrest.core.not;

	public class TreeAsserterTest {
		private static const c:TreeAsserter = new TreeAsserter();

		public function TreeAsserterTest() {
		}

		[Test]
		public function compareNull():void {
			var result:Object = c.isSubset(null, null);
			assertThat(result.result);
		}

		[Test]
		public function compareEmpty():void {
			var result:Object = c.isSubset(null, {});

			assertThat(not(result.result));
			assertThat(result.details.expectedValue, 'not null');
			assertThat(result.details.actualValue, 'null');
		}

		[Test]
		public function compare1Level_subTreeIsSubset():void {
			var tree:TreeCollectionEx = new TreeCollectionEx({ a: "b" });
			var subTree:Object = { vo: { a: "b" }};

			var result:Object = c.isSubset(tree, subTree);

			assertThat(result.result);
		}

		[Test]
		public function compare1Level_subTreeIsNotSubset_task():void {
			var tree:TreeCollectionEx = new TreeCollectionEx({ name: "foo" });
			var subTree:Object = { vo: { name: "bar" }};

			var result:Object = c.isSubset(tree, subTree);

			assertThat(not(result.result));
		}

		[Test]
		public function compare1Level_subTreeIsNotSubset():void {
			var tree:TreeCollectionEx = new TreeCollectionEx({ a: "b" });
			var subTree:Object = { vo: { a: "c" }};

			var result:Object = c.isSubset(tree, subTree);

			assertThat(not(result.result));
		}

		[Test]
		public function compare2Levels_subTreeIsSubset():void {
			var parent:TreeCollectionEx = new TreeCollectionEx({ parent: "parent" });
			var child1:TreeCollectionEx = new TreeCollectionEx({ child1: "child1" });
			var child2:TreeCollectionEx = new TreeCollectionEx({ child2: "child2" });
			parent.addChildren([ child1, child2 ]);

			var subTree:Object = { vo: { parent: "parent" }, children: [{ vo: { child1: "child1" }}, { vo: { child2: "child2" }}]};

			var result:Object = c.isSubset(parent, subTree);

			assertThat(result.result);
		}

		[Test]
		public function compare2Levels_subTreeIsNotSubset_differentValue():void {
			var parent:TreeCollectionEx = new TreeCollectionEx({ parent: "parent" });
			var child1:TreeCollectionEx = new TreeCollectionEx({ child1: "child1" });
			var child2:TreeCollectionEx = new TreeCollectionEx({ child2: "child2" });
			parent.addChildren([ child1, child2 ]);

			var subTree:Object = { vo: { parent: "parent" }, children: [{ vo: { child1: "child1" }}, { vo: { child2: "foo" }}]};

			var result:Object = c.isSubset(parent, subTree);

			assertThat(not(result.result));
		}

		[Test]
		public function compare2Levels_subTreeIsNotSubset_missing1Child():void {
			var parent:TreeCollectionEx = new TreeCollectionEx({ parent: "parent" });
			var child1:TreeCollectionEx = new TreeCollectionEx({ child1: "child1" });
			parent.addChildren([ child1 ]);

			var subTree:Object = { vo: { parent: "parent" }, children: [{ vo: { child1: "child1" }}, { vo: { child2: "child2" }}]};

			var result:Object = c.isSubset(parent, subTree);

			assertThat(not(result.result));
		}
	}
}
