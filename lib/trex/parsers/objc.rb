module Trex
  module Parsers
    class Objc < Trex::Parsers::Base

      def parser
        @parser ||= begin
          Treetop.load(grammar_path('base.treetop'))
          Treetop.load(grammar_path('objc.treetop'))
          ObjcParser.new
        end
      end

      def self.parse(data)
        # pp data

        tree = parser.parse(data)

        # pp @@rails_parser

        return nil if tree.nil?

        # pp tree

        clean_tree(tree)

        tree.to_array
      end

    end
  end
end
