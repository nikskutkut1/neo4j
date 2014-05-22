require 'neo4j/active_node/crel/conditions'

module Neo4j::ActiveNode
  module Crel
    class Query
      include Neo4j::ActiveNode::Conditions

      def initialize(label)
        @conditions = [MatchCondition.new("n:#{label}")]
      end

      def match(*args)
        build_deeper_query(MatchCondition, *args)
      end

      def where(*args)
        build_deeper_query(WhereCondition, *args)
      end

      def all
      end

      def first
      end

      def to_cypher
        conditions_by_class = @conditions.group_by(&:class)

        [MatchCondition, WhereCondition].map do |condition_class|
          conditions = conditions_by_class[condition_class]

          condition_class.to_cypher(conditions) if conditions
        end.compact.join ' '
      end

      protected

      def add_conditions(conditions)
        @conditions += conditions
      end

      private

      def build_deeper_query(condition_class, *args)
        self.dup.tap do |new_query|
          new_query.add_conditions condition_class.from_args(args)
        end
      end
    end
  end
end
