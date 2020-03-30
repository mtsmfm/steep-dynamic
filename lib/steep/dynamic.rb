require "steep/dynamic/version"

module Steep
  module Dynamic
    class AttrNodeProcessor
      def initialize(node, type_construction)
        @node = node
        @type_construction = type_construction
      end

      def process_attr_reader
        method_name = attr_name
        module_context.defined_instance_methods << method_name
      end

      def process_attr_writer
        method_name = :"#{attr_name}="
        module_context.defined_instance_methods << method_name
      end

      private

      def attr_name
        node.children[0]
      end

      def module_context
        type_construction.module_context
      end

      attr_reader :node, :type_construction
    end

    module TypeConstructionPatch
      def type_method_call(node, method_name:, receiver_type:, method:, args:, block_params:, block_body:, topdown_hint:)
        if method_name == :attr_reader
          node.children[2..-1].each do |attr_name_node|
            AttrNodeProcessor.new(attr_name_node, self).process_attr_reader
          end

          [AST::Builtin.any_type, nil]
        elsif method_name == :attr_writer
          node.children[2..-1].each do |attr_name_node|
            AttrNodeProcessor.new(attr_name_node, self).process_attr_writer
          end

          [AST::Builtin.any_type, nil]
        elsif method_name == :attr_accessor
          node.children[2..-1].each do |attr_name_node|
            AttrNodeProcessor.new(attr_name_node, self).process_attr_reader
            AttrNodeProcessor.new(attr_name_node, self).process_attr_writer
          end

          [AST::Builtin.any_type, nil]
        else
          super
        end
      end
    end
  end
end

Steep::TypeConstruction.prepend(Steep::Dynamic::TypeConstructionPatch)
